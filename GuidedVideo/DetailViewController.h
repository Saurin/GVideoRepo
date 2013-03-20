

#import <UIKit/UIKit.h>
#import "DetailViewManager.h"

@interface DetailViewController : UIViewController <SubstitutableDetailViewController>

@property(nonatomic,retain) NSMutableArray *feedbackArray;
@property(nonatomic,weak) IBOutlet UITableView *table;
@end
