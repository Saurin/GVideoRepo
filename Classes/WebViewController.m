

#import "WebViewController.h"

@implementation WebViewController {
    UIBarButtonItem *back, *forward, *activityButton, *site;
    UIActivityIndicatorView* activity;
}

#pragma mark View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    UIBarButtonItem *fspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fspace.width=20;
    forward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forwardIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardAction:)];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.frame=CGRectMake(0, 0, 20, 20);
    activity.center=self.view.center;
    activityButton = [[UIBarButtonItem alloc] initWithCustomView:activity];

    site = [[UIBarButtonItem alloc] initWithTitle:@"www.guidedvideo.com" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self setToolbarItems:[NSArray arrayWithObjects:activityButton,space,site,space,back,fspace,forward, nil]];
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.toolbar setTintColor:[UIColor blackColor]];
    

    [self updateBars];
}


-(void)viewWillAppear:(BOOL)animated 
{
    
    NSURL *url;
    url=[NSURL URLWithString:[self loadFor]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


- (void)viewDidUnload
{
    [self setWebView:nil];
    back=nil;
    forward=nil;
    activity=nil;
    activityButton=nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}



#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView*)webView 
{
    [activity startAnimating];
    [self updateBars];
}


- (void)webViewDidFinishLoad:(UIWebView*)webView {
    
    [activity stopAnimating];
    [self updateBars];
}


- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
	[self webViewDidFinishLoad:[self webView]];
}

#pragma Private methods

-(void)updateBars {
    
    back.enabled = [self.webView canGoBack];
    forward.enabled = [self.webView canGoForward];
}

-(IBAction)backAction:(id)sender
{
	[self.webView goBack];
}


-(IBAction)forwardAction:(id)sender
{
	[self.webView goForward];
}


@end
