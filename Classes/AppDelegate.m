
#import "AppDelegate.h"
#import "ApplicationNotification.h"
#import "Help.h"

@implementation AppDelegate{
    BOOL tutorialOn;
    
    UIScrollView *tutorialScrollView;
    UIPageControl *pager;
    UIButton *btnTutorialClose;
}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
	    
	// Initialize the app window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.splitViewController;

    [self.window makeKeyAndVisible];
    
    // The new popover look for split views was added in iOS 5.1.
    // This checks if the setting to enable it is available and
    // sets it to YES if so.
    if ([self.splitViewController respondsToSelector:@selector(setPresentsWithGesture:)])
        [self.splitViewController setPresentsWithGesture:YES];
    
    //show overlay, if needed
    [self showTutorialOverlay];
    
    //detect and make DB changes here....
    [self makeDBChanges];

    //get info array for help
    [self getInfo];

	return YES;
}

-(void) showTutorialOverlay{
    //check if need to display
    self.window.rootViewController = self.tutorialViewController;
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.height, self.window.frame.size.width)];
    [backImage setImage:[UIImage imageNamed:@"overlay.png"]];
    [self.tutorialViewController.view addSubview:backImage];
    
    tutorialScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.height, self.window.frame.size.width)];
    [tutorialScrollView setDelegate:self];
    [tutorialScrollView setContentSize:CGSizeMake(self.window.frame.size.height*3, self.window.frame.size.width)];
    [tutorialScrollView setBackgroundColor:[UIColor grayColor]];
    [tutorialScrollView setPagingEnabled:YES];
    [tutorialScrollView setScrollEnabled:YES];
    [tutorialScrollView setBounces:YES];
    [tutorialScrollView setAlpha:0.6];
    for (NSInteger i=0; i<3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.window.frame.size.height*i, 0, self.window.frame.size.height, self.window.frame.size.width)];
        imgView.image=[UIImage imageNamed:[@"" stringByAppendingFormat:@"overlay_%d.png",i+1]];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [tutorialScrollView addSubview:imgView];
    }
    [self.tutorialViewController.view addSubview:tutorialScrollView];

    pager = [[UIPageControl alloc] init];
    pager.center = tutorialScrollView.center;
    pager.frame = CGRectMake(pager.frame.origin.x, self.window.frame.size.width-30, pager.frame.size.width, pager.frame.size.height);
    pager.numberOfPages=3;
    [self.tutorialViewController.view addSubview:pager];
    
    btnTutorialClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnTutorialClose addTarget:self action:@selector(didCloseTutorialClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnTutorialClose setAlpha:0.2];
    [btnTutorialClose setFrame:CGRectMake(150, 660, 100, 50)];
    [self.tutorialViewController.view addSubview:btnTutorialClose];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page =  scrollView.contentOffset.x/1024;
    pager.currentPage=page;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [btnTutorialClose setHidden:YES];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [btnTutorialClose setHidden:NO];
}

-(void)makeDBChanges{

}

-(void)getInfo {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Help" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"Controllers"]];

    self.helpArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in controllers)
    {
        Help *help = [[Help alloc] initWithName:[dict valueForKey:@"Name"] purpose:[dict valueForKey:@"Purpose"] section:[dict valueForKey:@"Section"] action:[dict valueForKey:@"Action"] exit:[dict valueForKey:@"Exit"] nomenclature:[dict valueForKey:@"Nomenclature"]];
        help.guidedAccess = [dict valueForKey:@"GuidedAccess"];
        help.purpose2 = [dict valueForKey:@"Purpose2"];
        [self.helpArray addObject:help];
    }
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if([window.rootViewController isKindOfClass:[self.splitViewController class]]){
        //allow rotation
        return UIInterfaceOrientationMaskAll;
    }
    else{
        return UIInterfaceOrientationMaskLandscape;
    }
}

-(void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    
    [[ApplicationNotification notification] postNotificationChangeStatusBarOrientation:oldStatusBarOrientation];
}

-(IBAction)didCloseTutorialClick:(id)sender {
    self.window.rootViewController = self.splitViewController;
}

@end
