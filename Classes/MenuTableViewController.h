

#import <UIKit/UIKit.h>
#import "DetailViewManager.h"
#import "CustomButton.h"
#import "Data.h"

@interface MenuTableViewController : UITableViewController<SubstitutableDetailViewController>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
