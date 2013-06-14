
#import <UIKit/UIKit.h>
#import "DetailViewManager.h"
#import "CrudOp.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, UIScrollViewDelegate>
@property (nonatomic, retain) NSString *localSettingsPath;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *helpArray;

/// Things for IB
@property (nonatomic, strong) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, strong) IBOutlet UIViewController *tutorialViewController;

// DetailViewManager is assigned as the Split View Controller's delegate.
// However, UISplitViewController maintains only a weak reference to its
// delegate.  Someone must hold a strong reference to DetailViewManager
// or it will be deallocated after the interface is finished unarchieving.
@property (nonatomic, strong) IBOutlet DetailViewManager *detailViewManager;


-(IBAction)didCloseTutorialClick:(id)sender;
@end

