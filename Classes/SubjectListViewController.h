

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SubjectViewController.h"
#import "MenuTableViewController.h"
#import "SubjectViewChangeDelegate.h"

@interface SubjectListViewController : BaseViewController <SubstitutableDetailViewController, SubjectViewChangeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isListDetailController;

@end

