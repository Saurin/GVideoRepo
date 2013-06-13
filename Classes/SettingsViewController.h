

#import "BaseViewController.h"

@interface SettingsViewController : BaseViewController <SubstitutableDetailViewController, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

