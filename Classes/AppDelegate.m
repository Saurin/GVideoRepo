
#import "AppDelegate.h"
#import "ApplicationNotification.h"
#import "Help.h"

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
    
    
    //detect and make DB changes here....
    [self makeDBChanges];
    
    //get info array for help
    [self getInfo];
    
	return YES;
}

-(void)makeDBChanges{

    
    if(![[CrudOp sharedDB] isColumnExist:@"QuizName" inTable:DBTableQuiz]) {
        [[CrudOp sharedDB] addColumn:@"QuizName" dataType:@"varchar" inTable:DBTableQuiz];
        [[CrudOp sharedDB] UpdateTable:DBTableQuiz set:@"QuizName=''" where:@"1=1"];
    }
    
    if(![[CrudOp sharedDB] isColumnExist:@"AssetName" inTable:DBTableQuizOption]) {
        [[CrudOp sharedDB] addColumn:@"AssetName" dataType:@"varchar" inTable:DBTableQuizOption];
        [[CrudOp sharedDB] UpdateTable:DBTableQuiz set:@"AssetName=''" where:@"1=1"];
    }
    
}

-(void)getInfo {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Help" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"Controllers"]];

    self.helpArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in controllers)
    {
        [self.helpArray addObject:[[Help alloc] initWithName:[dict valueForKey:@"Name"] purpose:[dict valueForKey:@"Purpose"] section:[dict valueForKey:@"Section"] action:[dict valueForKey:@"Action"] exit:[dict valueForKey:@"Exit"]]];
    }
}

// -------------------------------------------------------------------------------
//	dealloc
// -------------------------------------------------------------------------------

-(void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    [[ApplicationNotification notification] postNotificationChangeStatusBarOrientation:oldStatusBarOrientation];
}

@end
