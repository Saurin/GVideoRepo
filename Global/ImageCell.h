

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ImageCellDelegate;

@interface ImageCell : UITableViewCell

@property (nonatomic, strong) id<ImageCellDelegate> delegate;
-(void)showImage:(UIImage *)image;
-(void)showIncompleteMessage:(BOOL)show;

@end

@protocol ImageCellDelegate <NSObject>
- (void) incompleteButtonClicked:(id)sender;
- (void)imageCell:(ImageCell *)imageCell didIncompleteButtonSelectAt:(CGPoint)point;
@end
