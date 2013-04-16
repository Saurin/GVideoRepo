
#import "DetailViewManager.h"

@interface DetailViewManager ()
// Holds a reference to the split view controller's bar button item
// if the button should be shown (the device is in portrait).
// Will be nil otherwise.
@property (nonatomic, strong) UIBarButtonItem *navigationPaneButtonItem;
// Holds a reference to the popover that will be displayed
// when the navigation button is pressed.
@property (nonatomic, strong) UIPopoverController *navigationPopoverController;

@property (nonatomic, strong) UIToolbar *masterToolBar;
@end


@implementation DetailViewManager

// -------------------------------------------------------------------------------
//	setDetailViewController:
//  Custom implementation of the setter for the detailViewController property.
// -------------------------------------------------------------------------------
- (void)setDetailViewController:(UIViewController<SubstitutableDetailViewController> *)detailViewController
{
    
    _detailViewController = detailViewController;

    // Update the split view controller's view controllers array.
    // This causes the new detail view controller to be displayed.
    UIViewController *navigationViewController = [self.splitViewController.viewControllers objectAtIndex:0];

    UINavigationController *detailNavController = [[UINavigationController alloc] initWithRootViewController:_detailViewController];
    [detailNavController.navigationBar setBarStyle:UIBarStyleBlack];
    
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:navigationViewController, detailNavController, nil];
    self.splitViewController.viewControllers = viewControllers;
    
}

- (void)setMasterViewController:(UIViewController<SubstitutableDetailViewController> *)masterViewController
{
    _masterViewController = masterViewController;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.splitViewController.viewControllers];
 
    UINavigationController *masterNavController = [[UINavigationController alloc] initWithRootViewController:_masterViewController];
    [masterNavController.navigationBar setBarStyle:UIBarStyleBlack];
    
    //add some animation here in future
    [viewControllers replaceObjectAtIndex:0 withObject:masterNavController];
    self.splitViewController.viewControllers = viewControllers;
    

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width=10;
    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btn addTarget:self action:@selector(didInfoClick:) forControlEvents:UIControlEventTouchDown];
    [info setCustomView:btn];

    [_masterViewController.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:space,info, nil]];

}

#pragma mark -
#pragma mark UISplitViewDelegate

// -------------------------------------------------------------------------------
//	splitViewController:shouldHideViewController:inOrientation:
// -------------------------------------------------------------------------------
- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{

    return NO;
}

-(IBAction)didInfoClick:(id)sender {

    [self.detailViewController didInfoClick:self.masterViewController];
}

@end
