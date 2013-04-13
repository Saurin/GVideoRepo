

#import <UIKit/UIKit.h>

/*
 SubstitutableDetailViewController defines the protocol that detail view controllers must adopt.
 The protocol specifies aproperty for the bar button item controlling the navigation pane.
 */
@protocol SubstitutableDetailViewController
//@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;
@end

@interface DetailViewManager : NSObject <UISplitViewControllerDelegate, UIApplicationDelegate>

/// Things for IB
// The split view this class will be managing.
@property (nonatomic, strong) IBOutlet UISplitViewController *splitViewController;

// The presently displayed detail view controller.  This is modified by the various 
// view controllers in the navigation pane of the split view controller.
@property (nonatomic, weak) IBOutlet UIViewController<SubstitutableDetailViewController> *detailViewController;
@property (nonatomic, weak) IBOutlet UIViewController<SubstitutableDetailViewController> *masterViewController;

@end
