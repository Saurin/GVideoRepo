
#import "MasterViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation MasterViewController {
    NSMutableArray *options;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.splitViewController.delegate=self;
    
    options = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"Configure Me",@"Play with Me",nil]
               ,[NSMutableArray arrayWithObjects:@"Tutorial",@"Settings",@"Feedback",nil]
               ,[NSMutableArray arrayWithObjects:@"Contact Us",@"About Us",nil]
               , nil];

    self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)selectedItem {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    return [(NSMutableArray *)[options objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [options count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSMutableArray *)[options objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue or create a cell of the appropriate type.
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text=[(NSMutableArray *)[options objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a reference to the DetailViewManager.
    // DetailViewManager is the delegate of our split view.
    DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {

        //selected object on table view
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id object = [(NSMutableArray *)[options objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

        if([[object description] isEqualToString:@"Configure Me"]){

            UIViewController <SubstitutableDetailViewController> *detailViewController = nil;

            SubjectListViewController *newDetailViewController = [[SubjectListViewController alloc] initWithNibName:@"SubjectList" bundle:nil];
            detailViewController = newDetailViewController;

            detailViewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            detailViewManager.detailViewController = detailViewController;

//            self.detailViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
//            
//            UIViewController *masterViewController = [self.splitViewController.viewControllers objectAtIndex:0];
//            NSArray *viewControllers = [[NSArray alloc] initWithObjects:masterViewController, self.detailViewController, nil];
//            self.splitViewController.viewControllers = viewControllers;
        }
        else if([[object description] isEqualToString:@"Play with Me"]){
            
            self.detailViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TopicsViewController"];
            [self.splitViewController presentViewController:self.detailViewController animated:YES completion:^{
                
            }];
        }
        else
        {
            self.detailViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            
            UIViewController *masterViewController = [self.splitViewController.viewControllers objectAtIndex:0];
            NSArray *viewControllers = [[NSArray alloc] initWithObjects:masterViewController, self.detailViewController, nil];
            self.splitViewController.viewControllers = viewControllers;
            
            [self performSelector:@selector(postNotificationAboutSelection:) withObject:[NSNotification notificationWithName:@"SelectedValue" object:object] afterDelay:0.1];
        }
    }
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
        if(self.detailViewController==nil){
            [self performSelector:@selector(loadDetailViewController) withObject:nil afterDelay:0.2];
        }
        return view;
    }
    
    return [[UIView alloc] init];
}


-(void)makeRoundRectView:(UIView *)view {
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;
}

-(void)loadDetailViewController {
    //load program view as default
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationTop];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

-(void)postNotificationAboutSelection:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification.name object:notification.object];
}

@end
