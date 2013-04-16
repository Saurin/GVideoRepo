

#import "BaseViewController.h"

@interface WebViewController : BaseViewController <SubstitutableDetailViewController, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString* loadFor;

@end
