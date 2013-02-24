

#import "TopicView_iPhone.h"
#import "CustomButton.h"

#define ButtonCount 9
#define VPadding 5
#define HPadding 15


@implementation TopicView_iPhone

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self loadButtons];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)redraw {
    
    [self loadButtons];
}

-(void)loadButtons {
    
    NSInteger tag=1;
    double buttonHeight = (self.frame.size.height-VPadding*4)/3;
    double buttonWidth = (self.frame.size.width-HPadding*4)/3;
    
    for (NSInteger i=1;i<ButtonCount;i++) {
        [[self viewWithTag:i] removeFromSuperview];
    }
    [[self viewWithTag:101] removeFromSuperview];
    
    
    int x=1,y=1;
    for(NSInteger i=0;i<=ButtonCount;i++){
        
        CGRect frame = CGRectMake(HPadding*x+buttonWidth*(x-1),VPadding*y+buttonHeight*(y-1), buttonWidth, buttonHeight);
        NSLog(@"%d %f %f %f %f",i, frame.size.height,frame.size.width,frame.origin.x,frame.origin.y);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];
        
        BOOL isEditable=NO;
        if([self.delegate respondsToSelector:@selector(isEditableButtonAtTag:)])
            isEditable = [self.delegate isEditableButtonAtTag:btn.tag];
        
        [btn setEditable:isEditable];
        btn.delegate=self.delegate;
        
        y++;
        if(y==4){
            y=1;
            x++;
        }
    }
}

@end
