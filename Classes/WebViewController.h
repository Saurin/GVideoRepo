

#import "BaseViewController.h"

@interface WebViewController : BaseViewController <SubstitutableDetailViewController, UIWebViewDelegate> {
    UIActivityIndicatorView* activity;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *activityButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goBackButton;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString* loadFor;
@property BOOL openLinksInSafari;
@property BOOL showToolBar;
@property BOOL showNavigationBar;


@end
