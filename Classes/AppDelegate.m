
#import "AppDelegate.h"
#import "ApplicationNotification.h"
#import "Help.h"
#import <AssetsLibrary/AssetsLibrary.h>

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
    [self loadDefaults];
    
    //get info array for help
    [self getInfo];
    
	return YES;
}

-(void)makeDBChanges{

    
//      AS OF NOW - 04/24/2013, WE DONT NEED IT.
//      THIS NEW RELEASE HAS NEW DB, INCLUDING BELOW COLUMNS AND SAMPLE SUBJECT
    
//    if(![[CrudOp sharedDB] isColumnExist:@"QuizName" inTable:DBTableQuiz]) {
//        [[CrudOp sharedDB] addColumn:@"QuizName" dataType:@"varchar" inTable:DBTableQuiz];
//        [[CrudOp sharedDB] UpdateTable:DBTableQuiz set:@"QuizName=''" where:@"1=1"];
//    }
//    
//    if(![[CrudOp sharedDB] isColumnExist:@"AssetName" inTable:DBTableQuizOption]) {
//        [[CrudOp sharedDB] addColumn:@"AssetName" dataType:@"varchar" inTable:DBTableQuizOption];
//        [[CrudOp sharedDB] UpdateTable:DBTableQuiz set:@"AssetName=''" where:@"1=1"];
//    }
    
}

-(void)loadDefaults {
    
    NSError *err=nil;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    NSString *copypath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Samples"];

    if(![fileMgr fileExistsAtPath:copypath]) {

        [fileMgr removeItemAtPath:copypath error:&err];
        if(![fileMgr copyItemAtPath:path toPath:copypath error:&err])
        {
            UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to Sample Subject." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [tellErr show];
            
            return;
        }
        
        
        //add subject
        NSString *url = [copypath stringByAppendingPathComponent:@"image-0.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:url];
        ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL * assertURL, NSError * error){
        
        [[CrudOp sharedDB] InsertRecordInTable:DBTableSubject withObject:[[Subject alloc] initWithName:@"Sample Subject" assetURL:[assertURL absoluteString]]];
        }];
        

        

    }
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

// -------------------------------------------------------------------------------
//	dealloc
// -------------------------------------------------------------------------------

-(void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    [[ApplicationNotification notification] postNotificationChangeStatusBarOrientation:oldStatusBarOrientation];
}

@end
