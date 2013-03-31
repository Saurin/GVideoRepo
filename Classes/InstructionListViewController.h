
#import "BaseViewController.h"
#import "InstructionViewController.h"
#import "SelectionChangeDelegate.h"

@interface InstructionListViewController : BaseViewController<SubstitutableDetailViewController,SelectionChangeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Subject *thisSubject;
@property BOOL isListDetailController;


@end
