
#import "AppDelegate.h"
#import "ApplicationNotification.h"
#import "Help.h"
#import "Utility.h"

@implementation AppDelegate

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
    BOOL show  = [[[Utility alloc] init] userSettingsExists:[NSString stringWithFormat:@"Settings%d",kShowTutorial]];
    //if key doesn't exists, force show
    if(!show){
        [[[Utility alloc] init] setUserSettings:YES keyName:[NSString stringWithFormat:@"Settings%d",kShowTutorial]];
        show=YES;
    }
    else{
        show  = [[[Utility alloc] init] getUserSettings:[NSString stringWithFormat:@"Settings%d",kShowTutorial]];
    }
    if(show)
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
        help.incomplete = [dict valueForKey:@"Incomplete"];
        [self.helpArray addObject:help];
    }
}

-(void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    
    [[ApplicationNotification notification] postNotificationChangeStatusBarOrientation:oldStatusBarOrientation];
}

-(void)CloseTutorial {
    self.window.rootViewController = self.splitViewController;
}

@end
