
#import <UIKit/UIKit.h>
#import "DetailViewManager.h"
#import "CrudOp.h"

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
/// Things for IB
@property (nonatomic, strong) IBOutlet UISplitViewController *splitViewController;
// DetailViewManager is assigned as the Split View Controller's delegate.
// However, UISplitViewController maintains only a weak reference to its
// delegate.  Someone must hold a strong reference to DetailViewManager
// or it will be deallocated after the interface is finished unarchieving.
@property (nonatomic, strong) IBOutlet DetailViewManager *detailViewManager;

@end

