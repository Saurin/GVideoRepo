

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "OHAlertView.h"
#import "Data.h"
#import "Subject.h"
#import "DetailViewManager.h"


@interface BaseViewController : UIViewController 

/// SubstitutableDetailViewController
@property (nonatomic, strong) UIBarButtonItem *navigationPaneBarButtonItem;
@property (nonatomic, strong) DetailViewManager *detailViewManager;

-(void)makeRoundRectView:(UIView *)view layerRadius:(NSInteger)radius;
@end
