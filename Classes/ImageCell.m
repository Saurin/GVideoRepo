
#import "ImageCell.h"
#import "Utility.h"

@implementation ImageCell

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
    
    self.imageView.bounds = CGRectMake(5,5,80,60);
    self.imageView.frame = CGRectMake(5,5,80,60);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeScaleAspectFill;

    [self makeRoundRectView:self.imageView];
    self.textLabel.bounds = CGRectMake(90, self.contentView.bounds.size.height/2-10, self.contentView.bounds.size.width-180, 20);
    self.textLabel.frame = CGRectMake(90, self.contentView.bounds.size.height/2-10, self.contentView.bounds.size.width-180, 20);
    
}

-(void)makeRoundRectView:(UIView *)view {
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
}

@end
