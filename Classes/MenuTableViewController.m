
#import "MenuTableViewController.h"
#import "DetailViewManager.h"
#import "DetailViewController.h"
#import "SubjectListViewController.h"
#import "PlayViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation MenuTableViewController {
     NSMutableArray *options;
    BaseViewController <SubstitutableDetailViewController> *detailViewController;
}


-(void)viewDidLoad
{
//    CustomButton *btn = [[CustomButton alloc] initWithFrame:CGRectMake(10, 10, 100, 60)];
//    btn.tag =1;
//    [self.view addSubview:btn];
//    [btn setHidden:NO];
//    [btn setEditable:YES];
//    btn.delegate=self;
//    btn.presentingController=self;
//
//  
//    Subject *thisSubject = [[Subject alloc] init];
//    thisSubject.subjectId=0;
//    thisSubject.subjectName=@"Math";
//    thisSubject.assetUrl=@"assets-library://asset/asset.JPG?id=168F7973-EFFA-49AF-B4D5-BB616E4F7451&ext=JPG";
//    [[Data sharedData] saveSubject:thisSubject];
//
//    thisSubject.subjectId=0;
//    thisSubject.subjectName=@"Science";
//    thisSubject.assetUrl=@"assets-library://asset/asset.JPG?id=B060981F-FAFF-4A69-8154-4BC64C247801&ext=JPG";
//    [[Data sharedData] saveSubject:thisSubject];
//
//    thisSubject.subjectId=0;
//    thisSubject.subjectName=@"Family";
//    thisSubject.assetUrl=@"assets-library://asset/asset.JPG?id=CC31A95B-8C4C-420A-8ADE-250FEF29CB78&ext=JPG";
//    [[Data sharedData] saveSubject:thisSubject];
//
//    NSMutableArray *subjects = [[Data sharedData] getSubjects];
    
    options = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"Configure Me",@"Play with Me",nil]
               ,[NSMutableArray arrayWithObjects:@"Tutorial",@"Settings",@"Feedback",nil]
               ,[NSMutableArray arrayWithObjects:@"Contact Us",@"About Us",nil]
               , nil];
    
    
    self.title = @"Guided Video";
    
    self.clearsSelectionOnViewWillAppear = NO;
}

#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [options count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSMutableArray *)[options objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    // Set appropriate labels for the cells.
    cell.textLabel.text = [(NSMutableArray *)[options objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark -
#pragma mark Table view selection

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get a reference to the DetailViewManager.
    // DetailViewManager is the delegate of our split view.
    
    // DetailViewManager exposes a property, detailViewController.  Set this property
    // to the detail view controller we want displayed.  Configuring the detail view
    // controller to display the navigation button (if needed) and presenting it
    // happens inside DetailViewManager.

    DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
    // Create and configure a new detail view controller appropriate for the selection.
    detailViewController = nil;
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    if(section==0){
        switch (row) {
            case 0:{

                SubjectListViewController *newDetailViewController = [[SubjectListViewController alloc] initWithNibName:@"SubjectListView" bundle:nil];
                [newDetailViewController setIsListDetailController:YES];
                detailViewController = newDetailViewController;

                break;
            }
            case 1:{

                PlayViewController *newDetailViewController = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
                [self.navigationController presentModalViewController:newDetailViewController animated:YES];
                
                return nil;             //we dont want play me shown selected

                break;
            }
            default:
                break;
        }

            
    }
    else{
        
        DetailViewController *newDetailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
        detailViewController = newDetailViewController;
    }
    
    detailViewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    detailViewManager.detailViewController = detailViewController;
    
    return indexPath;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
       && section==[options count]-1){
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GuidedVideo.png"]];
        [imageView setContentMode:UIViewContentModeCenter];
        [self makeRoundRectView:imageView];
        imageView.frame=CGRectMake((self.view.bounds.size.width-imageView.frame.size.width)/2, 30, imageView.frame.size.width, imageView.frame.size.height);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        [view addSubview:imageView];
        
        //Now load default detail view, if not loaded
        if(detailViewController==nil){
            [self performSelector:@selector(loadDefaultDetailViewController) withObject:nil afterDelay:0.2];
        }
        return view;
    }
    
    return [[UIView alloc] init];
}

-(void)loadDefaultDetailViewController {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationTop];
    [self tableView:self.tableView willSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

-(void)makeRoundRectView:(UIView *)view {
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
