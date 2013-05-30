

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ImageCell : UITableViewCell

-(void)showImage:(UIImage *)image;
-(void)showIncompleteMessage:(BOOL)show;
@end
