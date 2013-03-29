
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
	// Do any additional setup after loading the view.
    
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
}

-(void)viewWillAppear:(BOOL)animated
{
    instructions = [[Data sharedData] getSubjectAtSubjectId:self.thisSubject.subjectId].quizPages;
    
    //add empty subject for Detail View Controller, change its master view controller if changed during push
    if(self.isListDetailController){
        
        self.title = @"Instructions";
        
        //we want to give only 5 instructions as free....
        if([instructions count]<5){
            QuizPage *quizPage = [[QuizPage alloc] init];
            quizPage.subjectId=self.thisSubject.subjectId;
            quizPage.quizId=0;
            quizPage.quizName=@"Add a new Instruction";
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
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //dont want to reuse cell as we have cell image getting added on a different queue
    ImageCell *cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if(self.isListDetailController){
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    QuizPage *page = [instructions objectAtIndex:indexPath.row];
    cell.textLabel.text = page.quizName;
    cell.detailTextLabel.text=page.videoUrl;
    
    cell.tag = page.quizId;
    
    UIImage *img = [[Utility alloc] getThumbnailFromVideoURL:page.videoUrl];
    [cell.imageView setImage:img];
    [cell setEditing:YES];
    [cell setEditing:NO];

    return cell;
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
        
//        BaseViewController *someController = (SubjectViewController *)self.detailViewManager.detailViewController;
//        if([[someController.navigationController.viewControllers lastObject] isKindOfClass:[SubjectViewController class]]){
//            
//            SubjectViewController *subjectViewController = [someController.navigationController.viewControllers lastObject];
//            [subjectViewController didSubjectSelectionChange:[subjects objectAtIndex:indexPath.row]];
//        }
        
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
        //[instructionViewController setDelegate:masterViewController];
        [instructionViewController setIsDetailController:YES];
        [self.navigationController pushViewController:instructionViewController animated:YES];
    }
}

@end
