
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DetailViewController : BaseViewController <SubstitutableDetailViewController>

@property (nonatomic) NSString *sender;
@end
