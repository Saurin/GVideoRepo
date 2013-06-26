
#import "AlternativeListViewController.h"
#import "InstructionViewController.h"
#import "AlternativeViewController.h"
#import <objc/runtime.h>

static char * const myIndexPathAssociationKey = "";
@implementation AlternativeListViewController{
    NSMutableArray *alternatives;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"AlternativeListViewController" object:nil];
    
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
}

-(void)viewWillAppear:(BOOL)animated
{
    alternatives = [[Data sharedData] getQuizOptionsForQuizId:self.quizPage.quizId];
    
    //add empty subject for Detail View Controller, change its master view controller if changed during push
    if(self.isListDetailController){
        [self setOtherRightBarButtons:nil];
        self.title = @"Alternatives";
        
        //we want to give only 12 options per quiz....
        if([alternatives count]<12){
            QuizOption *option = [[QuizOption alloc] init];
            option.quizId=self.quizPage.quizId;
            option.quizOptionId=0;
            [alternatives addObject:option];
        }
        
        //change it to InstructionViewController
        if(![self.detailViewManager.masterViewController isKindOfClass:[InstructionViewController class]]){
            InstructionViewController *masterViewController = [[InstructionViewController alloc] initWithNibName:@"InstructionView" bundle:nil];
            [masterViewController setThisQuiz:[[Data sharedData] getQuizAtQuizId:self.quizPage.quizId]];
            [self.detailViewManager setMasterViewController:masterViewController];
        }
    }
    else {
        self.title = @"Alternatives";
    }
    
    [self.tableView setRowHeight:75];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleNotification:(NSNotification*)note {
    //ignore other notifications, we may receive
    
    if([note.name isEqualToString:@"AlternativeListViewController"]){
        if([note.object isKindOfClass:[QuizOption class]]){
            
            NSInteger index = [alternatives indexOfObject:note.object];
            if(index<alternatives.count){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
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
    return [alternatives count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuizOption *thisOption = [alternatives objectAtIndex:indexPath.row];
    
    //No image, regular UITableViewCell for Add Subject cell...
    if(self.isListDetailController && thisOption.quizOptionId==0){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text = @"Add a new Alternative...";
        cell.tag = thisOption.quizOptionId;
        
        return cell;
        
    }
    else{
        
        //dont want to reuse cell as we have cell image getting added on a different queue
        ImageCell *cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        if(self.isListDetailController){
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        cell.textLabel.text = thisOption.assetName;
        cell.tag = thisOption.quizOptionId;
        
        // Store a reference to the current cell that will enable the image to be associated with the correct
        // cell, when the image subsequently loaded asynchronously. Without this, the image may be mis-applied
        // to a cell that has been dequeued and reused for other content, during rapid scrolling.
        objc_setAssociatedObject(cell, myIndexPathAssociationKey, indexPath, OBJC_ASSOCIATION_ASSIGN);
        
        // Load the image on a high priority background queue using Grand Central Dispatch.
        // Can change priority by replacing HIGH with DEFAULT or LOW if desired.
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{
            
            [[Utility alloc] getImageFromAssetURL:thisOption.assetUrl completion:^(NSString *url, UIImage *image) {
                
                // Code to actually update the cell once the image is obtained must be run on the main queue.
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *cellIndexPath = (NSIndexPath *)objc_getAssociatedObject(cell, myIndexPathAssociationKey);
                    if ([indexPath isEqual:cellIndexPath]) {
                        // Only set cell image if the cell currently being displayed is the one that actually required this image.
                        // Prevents reused cells from receiving images back from rendering that were requested for that cell in a previous life.
                        
                        [cell showImage:image];
                        QuizOption *opt = [alternatives objectAtIndex:indexPath.row];
                        if(![[Data sharedData] isQuizOptionProgrammed:opt.quizOptionId]){
                            [cell showIncompleteMessage:YES];
                        }
                        else{
                            [cell showIncompleteMessage:NO];
                        }
                    }
                });
            }];
        });
        
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.isListDetailController?@"Alternatives":@"";
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //send notification to detail view that user wants to change subject selection
    if(!self.isListDetailController) {
        //As we have pushed a view controller using navigation controller, get latest object on detailViewController
        //this should be current detail view, user is seeing.
        
        BaseViewController *someController = (InstructionViewController *)self.detailViewManager.detailViewController;
        if([[someController.navigationController.viewControllers lastObject] isKindOfClass:[AlternativeViewController class]]){
            
            AlternativeViewController *alternativeViewController = [someController.navigationController.viewControllers lastObject];
            [alternativeViewController didOptionSelectionChange:[alternatives objectAtIndex:indexPath.row]];
        }
        
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isListDetailController){
        
        AlternativeListViewController *masterViewController = [[AlternativeListViewController alloc] initWithNibName:@"AlternativeListView" bundle:nil];
        [masterViewController setIsListDetailController:NO];
        [masterViewController setQuizPage:self.quizPage];
        [self.detailViewManager setMasterViewController:masterViewController];
        
        AlternativeViewController *alternativeViewController = [[AlternativeViewController alloc] initWithNibName:@"AlternativeView" bundle:nil];
        [alternativeViewController setQuizOption:[alternatives objectAtIndex:indexPath.row]];
        [alternativeViewController setDelegate:masterViewController];
        [alternativeViewController setIsDetailController:YES];
        [self.navigationController pushViewController:alternativeViewController animated:YES];
    }
}


-(void)didOptionChange:(QuizOption *)newOption  {
    
    alternatives = [[Data sharedData] getQuizOptionsForQuizId:self.quizPage.quizId];
    [self.tableView reloadData];
}

-(void)imageCell:(ImageCell *)imageCell didIncompleteButtonSelectAt:(CGPoint)point {
    
    for (NSInteger cnt=0; cnt<alternatives.count; cnt++) {
        
        ImageCell *cell=(ImageCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:cnt inSection:0]];
        if(cell==imageCell){
            QuizOption *option=[alternatives objectAtIndex:cnt];
            [self showErrorMessageFor:option];
            break;
        }
    }
}

-(void)showErrorMessageFor:(QuizOption *)option {
    
    [[[Message alloc] initAlternativeIncompleteMessageWithTitle:option.assetName
                                          cancelButtonTitle:@"OK"] showWithTimeout:5
                                                timeoutButtonIndex:0];
    
}

@end
