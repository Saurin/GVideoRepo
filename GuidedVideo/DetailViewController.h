

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UISplitViewControllerDelegate>

@property(nonatomic,retain) NSMutableArray *feedbackArray;
@property(nonatomic,weak) IBOutlet UITableView *table;
@end
