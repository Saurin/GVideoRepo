
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DetailViewController : BaseViewController <SubstitutableDetailViewController>

@property (nonatomic) NSIndexPath *menuAtIndexPath;

@end
