
#import "InstructionListViewController.h"
#import "SubjectViewController.h"
#import <objc/runtime.h>
#import "ImageCell.h"

static char * const myIndexPathAssociationKey = "";
@implementation InstructionListViewController{
    NSMutableArray *instructions;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"InstructionListViewController" object:nil];
    
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
}

-(void)viewWillAppear:(BOOL)animated
{
    instructions = [[Data sharedData] getSubjectAtSubjectId:self.thisSubject.subjectId].quizPages;
    
    //add empty subject for Detail View Controller, change its master view controller if changed during push
    if(self.isListDetailController){
        [self setOtherRightBarButtons:nil];
        self.title = @"Instructions";
        
        //we want to give only 5 instructions as free....
        if([instructions count]<5){
            QuizPage *quizPage = [[QuizPage alloc] init];
            quizPage.subjectId=self.thisSubject.subjectId;
            quizPage.quizId=0;
            quizPage.quizName=@"Add a new Instruction...";
            quizPage.quizOptions=[[NSMutableArray alloc] init];

            [instructions addObject:quizPage];
        }
        
        //if masterviewcontroller is not SubjectView, change it to SubjectViewController
        if(![self.detailViewManager.masterViewController isKindOfClass:[SubjectViewController class]]){
            SubjectViewController *menuController = [[SubjectViewController alloc] initWithNibName:@"SubjectView" bundle:nil];
            [menuController setThisSubject:self.thisSubject];
            [menuController setIsDetailController:NO];
            [self.detailViewManager setMasterViewController:menuController];
        }
    }
    else {
        self.title = @"Instructions";
    }
    
    [self.tableView setRowHeight:75];
    if(instructions.count>0)
        [self getVideoThumbnails:0];
}

-(void)getVideoThumbnails:(NSInteger)index {
    __block NSInteger idx=index;

    @try {
        if(((QuizPage *)[instructions objectAtIndex:index]).quizId!=0){    //we need no image for "Add a new..."
            [[[Utility alloc] init] getThumbnailFromVideoURL:((QuizPage *)[instructions objectAtIndex:index]).videoUrl completion:^(NSString *url, UIImage *image) {
                
                ((QuizPage *)[instructions objectAtIndex:idx]).imgThumb = image;
                if(idx+1<instructions.count)
                    [self getVideoThumbnails:idx+1];
                
                return;
            }];
        }
        
        [self.tableView reloadData];

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleNotification:(NSNotification*)note {
    //ignore other notifications, we may receive
    
    if([note.name isEqualToString:@"InstructionListViewController"]){
        if([note.object isKindOfClass:[QuizPage class]]){
            
            NSInteger index = [instructions indexOfObject:note.object];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [instructions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuizPage *page = [instructions objectAtIndex:indexPath.row];
    
    //No image, regular UITableViewCell for Add Subject cell...
    if(self.isListDetailController && page.quizId==0){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text = page.quizName;
        cell.tag=page.quizId;
        
        return cell;
        
    }
    else{
        
        //dont want to reuse cell as we have cell image getting added on a different queue
        ImageCell *cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

        if(self.isListDetailController){
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        cell.textLabel.text = page.quizName;
        cell.tag = page.quizId;
        
        // Store a reference to the current cell that will enable the image to be associated with the correct
        // cell, when the image subsequently loaded asynchronously. Without this, the image may be mis-applied
        // to a cell that has been dequeued and reused for other content, during rapid scrolling.
        objc_setAssociatedObject(cell, myIndexPathAssociationKey, indexPath, OBJC_ASSOCIATION_ASSIGN);
        
        // Load the image on a high priority background queue using Grand Central Dispatch.
        // Can change priority by replacing HIGH with DEFAULT or LOW if desired.
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{

            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *cellIndexPath = (NSIndexPath *)objc_getAssociatedObject(cell, myIndexPathAssociationKey);
                if ([indexPath isEqual:cellIndexPath]) {
                    // Only set cell image if the cell currently being displayed is the one that actually required this image.
                    // Prevents reused cells from receiving images back from rendering that were requested for that cell in a previous life.
                    
                    [cell showImage:((QuizPage *)[instructions objectAtIndex:indexPath.row]).imgThumb];
                }
            });

        });


        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.isListDetailController?@"Instructions":@"";
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //send notification to detail view that user wants to change subject selection
    if(!self.isListDetailController) {
        //As we have pushed a view controller using navigation controller, get latest object on detailViewController
        //this should be current detail view, user is seeing.
        
        BaseViewController *someController = (InstructionViewController *)self.detailViewManager.detailViewController;
        if([[someController.navigationController.viewControllers lastObject] isKindOfClass:[InstructionViewController class]]){
            
            InstructionViewController *instructionViewController = [someController.navigationController.viewControllers lastObject];
            [instructionViewController didQuizSelectionChange:[instructions objectAtIndex:indexPath.row]];
        }
        
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isListDetailController){
        
        InstructionListViewController *masterViewController = [[InstructionListViewController alloc] initWithNibName:@"InstructionListView" bundle:nil];
        [masterViewController setIsListDetailController:NO];
        [masterViewController setThisSubject:self.thisSubject];
        [self.detailViewManager setMasterViewController:masterViewController];
        
        InstructionViewController *instructionViewController = [[InstructionViewController alloc] initWithNibName:@"InstructionView" bundle:nil];
        [instructionViewController setThisQuiz:[instructions objectAtIndex:indexPath.row]];
        [instructionViewController setDelegate:masterViewController];
        [instructionViewController setIsDetailController:YES];
        [self.navigationController pushViewController:instructionViewController animated:YES];
    }
}

-(void)didQuizChange:(QuizPage *)newQuiz {
    
    instructions = [[Data sharedData] getSubjectAtSubjectId:self.thisSubject.subjectId].quizPages;
    [self getVideoThumbnails:0];    //this internally calls reload table
}

@end
