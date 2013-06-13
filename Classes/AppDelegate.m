
#import "AppDelegate.h"
#import "ApplicationNotification.h"
#import "Help.h"

@implementation AppDelegate{
    BOOL tutorialOn;
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
    [self.tutorialScrollView setContentSize:CGSizeMake(self.window.frame.size.height*3, self.window.frame.size.width)];
    for (NSInteger i=0; i<3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.window.frame.size.height*i, 0, self.window.frame.size.height, self.window.frame.size.width)];
        imgView.image=[UIImage imageNamed:[@"" stringByAppendingFormat:@"overlay%d.png",i]];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [self.tutorialScrollView addSubview:imgView];
    }
    [self.window.rootViewController.view sendSubviewToBack:self.tutorialScrollView];
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
