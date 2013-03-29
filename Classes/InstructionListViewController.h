
#import "BaseViewController.h"
#import "InstructionViewController.h"

@interface InstructionListViewController : BaseViewController<SubstitutableDetailViewController>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Subject *thisSubject;
@property BOOL isListDetailController;


@end
