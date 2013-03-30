
#import "ImageCell.h"
#import "Utility.h"

@implementation ImageCell {
    UIImageView *imgCurrent;
    UIActivityIndicatorView *activity;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews {
 
    [super layoutSubviews];
    
    if(imgCurrent==nil){
        imgCurrent = [[UIImageView alloc] initWithFrame:CGRectMake(5,self.contentView.bounds.size.height/2-30,75,60)];
        [self makeRoundRectView:imgCurrent];
        [self.contentView addSubview:imgCurrent];

        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [imgCurrent addSubview:activity];
        activity.center = imgCurrent.center;
        [activity startAnimating];
    }

    self.textLabel.bounds = CGRectMake(85, self.contentView.bounds.size.height/2-10, self.contentView.bounds.size.width-160, 20);
    self.textLabel.frame = CGRectMake(85, self.contentView.bounds.size.height/2-10, self.contentView.bounds.size.width-160, 20);
}

-(void)makeRoundRectView:(UIView *)view {
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
}

-(void)showImage:(UIImage *)image {
    [imgCurrent setImage:image];
    [activity stopAnimating];
    [activity removeFromSuperview];
}

-(void)dealloc {
    imgCurrent=nil;
    activity=nil;
}

@end
