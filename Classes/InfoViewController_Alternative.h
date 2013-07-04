
#import "BaseModelViewController.h"
#import "AppDelegate.h"
#import "Help.h"

@interface InfoViewController_Alternative : BaseModelViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *sender;
-(IBAction)didDoneClick:(id)sender;

@end
