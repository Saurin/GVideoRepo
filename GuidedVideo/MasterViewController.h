
#import <UIKit/UIKit.h>
#import "DetailViewManager.h"
#import "DetailViewController.h"
#import "TopicsViewController.h"
#import "SubjectListViewController.h"


@interface MasterViewController : UITableViewController<UISplitViewControllerDelegate>

@property (nonatomic, retain) DetailViewManager *detailViewManager;
@property(nonatomic,retain) UIViewController *detailViewController;

@end


