

#import "WebViewController.h"
#import "AppDelegate.h"

@implementation WebViewController
@synthesize goBackButton;
@synthesize activityButton;

@synthesize backButton, forwardButton, webView;
@synthesize loadFor, openLinksInSafari, showToolBar, showNavigationBar;

//this is a test by mike myers
#pragma mark View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.frame=CGRectMake(0, 0, 20, 20);
    activity.center=self.view.center;
    
    [activityButton setCustomView:activity];
    
    backButton.target=self;
    backButton.action = @selector(backAction:);
    
    forwardButton.target=self;
    forwardButton.action=@selector(forwardAction:);
    
    goBackButton.target=self;
    goBackButton.action=@selector(goBack:);
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"MugShotsBack.png"] forState:UIControlStateNormal];
    [goBackButton setCustomView:btn];
    
    [self updateBars];
}


-(void)viewWillAppear:(BOOL)animated 
{
    //we have a transulcent bar for other pages
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlack];
    
    NSURL *url;
    url=[NSURL URLWithString:[self loadFor]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


- (void)viewDidUnload
{
    //we have a transulcent bar for other pages
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    [self setWebView:nil];
    [self setBackButton:nil];
    [self setForwardButton:nil];
    [self setActivityButton:nil];
    [self setGoBackButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}



#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
    //cars.iaai.com has a embedded youtube video, which requires following code to play video
    NSRange result=[request.URL.absoluteString rangeOfString:@"http://www.youtube.com"];
    if(result.length>0){
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked && openLinksInSafari){
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    else {
        return YES;
    }
}


- (void)webViewDidStartLoad:(UIWebView*)webView 
{
    [activity startAnimating];
    [self updateBars];
}


- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self updateBars];
    [activity stopAnimating];
}


- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
	[self webViewDidFinishLoad:[self webView]];
}

#pragma Private methods

-(void)updateBars {
    [self.navigationController setToolbarHidden:showToolBar];
    [self.navigationController setNavigationBarHidden:showNavigationBar];
    
	backButton.enabled = [[self webView] canGoBack];
	forwardButton.enabled = [[self webView] canGoForward];
}

-(IBAction)backAction:(id)sender
{
	[self.webView goBack];
}


-(IBAction)forwardAction:(id)sender
{
	[self.webView goForward];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
