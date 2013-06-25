
#import "BaseViewController.h"
#import "InstructionViewController.h"
#import "SelectionChangeDelegate.h"
#import "ImageCell.h"

@interface InstructionListViewController : BaseViewController<SubstitutableDetailViewController,SelectionChangeDelegate, ImageCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Subject *thisSubject;
@property BOOL isListDetailController;


@end
