

#import "BaseModelViewController.h"
#import "QuizViewController.h"

@interface PlayViewController : BaseModelViewController <SubstitutableDetailViewController>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
