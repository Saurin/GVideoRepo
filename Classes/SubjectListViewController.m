

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

    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    subjects = [[Data sharedData] getSubjects];
    
    //add empty subject for Detail View Controller, change its master view controller if changed during push
    if(self.isListDetailController){
        Subject *sub = [[Subject alloc] init];
        sub.subjectId=-1;
        sub.subjectName=@"Add Subject...";
        [subjects addObject:sub];
    
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
    //dont want to reuse cell as we have cell image getting added on a different queue
    ImageCell *cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if(self.isListDetailController){
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    Subject *thisSubject = [subjects objectAtIndex:indexPath.row];
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

        [[Utility alloc] setImageFromAssetURL:thisSubject.assetUrl completion:^(NSString *url, UIImage *image) {

            // Code to actually update the cell once the image is obtained must be run on the main queue.
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *cellIndexPath = (NSIndexPath *)objc_getAssociatedObject(cell, myIndexPathAssociationKey);
                if ([indexPath isEqual:cellIndexPath]) {
                    // Only set cell image if the cell currently being displayed is the one that actually required this image.
                    // Prevents reused cells from receiving images back from rendering that were requested for that cell in a previous life.

                    [cell.imageView setImage:image];
                        
                    //to force to display image
                    [cell setEditing:YES];
                    [cell setEditing:NO];
                }
            });
        }];
    });
    
    return cell;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.isListDetailController?@"Subjects":@"";
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
        [self.navigationController pushViewController:subjectViewController animated:YES];
       
    }
    //send notification to detail view that user wants to change subject selection
    else {
        //As we have pushed a view controller using navigation controller, get latest object on detailViewController
        //this should be current detail view, user is seeing.

        BaseViewController *someController = (SubjectViewController *)self.detailViewManager.detailViewController;
        SubjectViewController *subjectViewController = [someController.navigationController.viewControllers lastObject];
        [subjectViewController didSubjectSelectionChange:[subjects objectAtIndex:indexPath.row]];
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
