

#import "SubjectListViewController.h"
#import <objc/runtime.h>
#import "ImageCell.h"

static char * const myIndexPathAssociationKey = "";
@implementation SubjectListViewController {
    NSMutableArray *subjects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"SubjectListViewController" object:nil];
    
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
}

-(void)viewWillAppear:(BOOL)animated
{
    subjects = [[Data sharedData] getSubjects];
    
    //add empty subject for Detail View Controller, change its master view controller if changed during push
    if(self.isListDetailController){
        
        //we want to give only 12 subjects as free....
        if([subjects count]<12){
            Subject *sub = [[Subject alloc] init];
            sub.subjectId=-1;
            sub.subjectName=@"Add Subject...";
            [subjects addObject:sub];
        }
    
        //if masterviewcontroller is not menu, change it to MenuTableViewController
        if(![self.detailViewManager.masterViewController isKindOfClass:[MenuTableViewController class]]){
            MenuTableViewController *menuController = [[MenuTableViewController alloc] initWithNibName:@"MenuView" bundle:nil];
            [self.detailViewManager setMasterViewController:menuController];
        }
    }
    else {
        self.title = @"Subjects";
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
    
    if([note.name isEqualToString:@"SubjectListViewController"]){
        if([note.object isKindOfClass:[Subject class]]){

            NSInteger index = [subjects indexOfObject:note.object];
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
    return [subjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Subject *thisSubject = [subjects objectAtIndex:indexPath.row];

    //No image, regular UITableViewCell for Add Subject cell...
    if(self.isListDetailController && indexPath.row==[subjects count]-1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        cell.textLabel.text = thisSubject.subjectName;
        cell.tag = thisSubject.subjectId;
        
        return cell;
        
    }
    else{

        //dont want to reuse cell as we have cell image getting added on a different queue
        ImageCell *cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        if(self.isListDetailController){
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        cell.textLabel.text = thisSubject.subjectName;
        cell.tag = thisSubject.subjectId;
        
        // Store a reference to the current cell that will enable the image to be associated with the correct
        // cell, when the image subsequently loaded asynchronously. Without this, the image may be mis-applied
        // to a cell that has been dequeued and reused for other content, during rapid scrolling.
        objc_setAssociatedObject(cell, myIndexPathAssociationKey, indexPath, OBJC_ASSOCIATION_ASSIGN);
        
        // Load the image on a high priority background queue using Grand Central Dispatch.
        // Can change priority by replacing HIGH with DEFAULT or LOW if desired.
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{

            [[Utility alloc] getImageFromAssetURL:thisSubject.assetUrl completion:^(NSString *url, UIImage *image) {

                // Code to actually update the cell once the image is obtained must be run on the main queue.
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *cellIndexPath = (NSIndexPath *)objc_getAssociatedObject(cell, myIndexPathAssociationKey);
                    if ([indexPath isEqual:cellIndexPath]) {
                        // Only set cell image if the cell currently being displayed is the one that actually required this image.
                        // Prevents reused cells from receiving images back from rendering that were requested for that cell in a previous life.

                        [cell showImage:image];
                    }
                });
            }];
        });

        return cell;
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.isListDetailController?@"Subjects":@"";
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //send notification to detail view that user wants to change subject selection
    if(!self.isListDetailController) {
        //As we have pushed a view controller using navigation controller, get latest object on detailViewController
        //this should be current detail view, user is seeing.
        
        BaseViewController *someController = (SubjectViewController *)self.detailViewManager.detailViewController;
        if([[someController.navigationController.viewControllers lastObject] isKindOfClass:[SubjectViewController class]]){
            
            SubjectViewController *subjectViewController = [someController.navigationController.viewControllers lastObject];
            [subjectViewController didSubjectSelectionChange:[subjects objectAtIndex:indexPath.row]];
        }
        
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isListDetailController){
        
        SubjectListViewController *masterViewController = [[SubjectListViewController alloc] initWithNibName:@"SubjectListView" bundle:nil];
        [masterViewController setIsListDetailController:NO];
        [self.detailViewManager setMasterViewController:masterViewController];
        
        SubjectViewController *subjectViewController = [[SubjectViewController alloc] initWithNibName:@"SubjectView" bundle:nil];
        [subjectViewController setThisSubject:[subjects objectAtIndex:indexPath.row]];
        [subjectViewController setDelegate:masterViewController];
        [subjectViewController setIsDetailController:YES];
        [self.navigationController pushViewController:subjectViewController animated:YES];
    }
}

#pragma Subject Change notification
-(void)didSubjectChange:(Subject *)newSubject {
    
    //new subject received, lets just refresh our table view
    //here we assume, this notification will only be received when SubjectList is a masterviewcontroller
    subjects = [[Data sharedData] getSubjects];
    [self.tableView reloadData];
}

@end
