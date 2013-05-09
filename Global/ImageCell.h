

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ImageCell : UITableViewCell

@property (nonatomic, retain) UILabel *incompleteLabel;
-(void)showImage:(UIImage *)image;
-(void)showIncompleteMessage:(BOOL)show;
@end
