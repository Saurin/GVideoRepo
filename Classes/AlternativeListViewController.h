

#import "BaseViewController.h"
#import "SelectionChangeDelegate.h"
#import "DetailViewManager.h"

@interface AlternativeListViewController : BaseViewController<SubstitutableDetailViewController, SelectionChangeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isListDetailController;
@property (nonatomic,strong) QuizPage *quizPage;

@end
