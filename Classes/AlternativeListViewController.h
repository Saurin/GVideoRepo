

#import "BaseViewController.h"
#import "SelectionChangeDelegate.h"
#import "DetailViewManager.h"
#import "ImageCell.h"

@interface AlternativeListViewController : BaseViewController<SubstitutableDetailViewController, SelectionChangeDelegate, ImageCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isListDetailController;
@property (nonatomic,strong) QuizPage *quizPage;

@end
