
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface PreviewViewController : BaseViewController<SubstitutableDetailViewController>

@property (nonatomic,strong) NSString *videoUrl;
-(IBAction)click:(id)sender;

@end
