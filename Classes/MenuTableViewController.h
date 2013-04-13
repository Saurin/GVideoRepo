

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DetailViewManager.h"
#import "CustomButton.h"
#import "Data.h"

@interface MenuTableViewController : UITableViewController<SubstitutableDetailViewController,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
