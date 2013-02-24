

#import "TopicView_iPad.h"
#import "CustomButton.h"

#define ButtonCount 16
#define VPadding 20
#define HPadding 40


@implementation TopicView_iPad

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
    double buttonHeight = (self.frame.size.height-VPadding*6)/5;
    double buttonWidth = (self.frame.size.width-HPadding*6)/5;
    
    for (NSInteger i=1;i<ButtonCount;i++) {
        [[self viewWithTag:i] removeFromSuperview];
    }
    [[self viewWithTag:101] removeFromSuperview];
    
    //bottom row
    for(NSInteger i=0;i<5;i++){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, self.frame.size.height-buttonHeight-VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];
        
        BOOL isEditable=NO;
        if([self.delegate respondsToSelector:@selector(isEditableButtonAtTag:)])
            isEditable = [self.delegate isEditableButtonAtTag:btn.tag];
        
        [btn setEditable:isEditable];
        btn.delegate=self.delegate;
    }
    
    //right column
    for(NSInteger i=3;i>0;i--){
        
        CGRect frame = CGRectMake(self.frame.size.width-buttonWidth-HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];
        
        BOOL isEditable=NO;
        if([self.delegate respondsToSelector:@selector(isEditableButtonAtTag:)])
            isEditable = [self.delegate isEditableButtonAtTag:btn.tag];
        
        [btn setEditable:isEditable];
        btn.delegate=self.delegate;
    }
    
    
    //top row
    for(NSInteger i=4;i>=0;i--){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];
        
        BOOL isEditable=NO;
        if([self.delegate respondsToSelector:@selector(isEditableButtonAtTag:)])
            isEditable = [self.delegate isEditableButtonAtTag:btn.tag];
        
        [btn setEditable:isEditable];
        btn.delegate=self.delegate;
    }
    
    //left column
    for(NSInteger i=1;i<=3;i++){
        
        CGRect frame = CGRectMake(HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];
        
        BOOL isEditable=NO;
        if([self.delegate respondsToSelector:@selector(isEditableButtonAtTag:)])
            isEditable = [self.delegate isEditableButtonAtTag:btn.tag];
        
        [btn setEditable:isEditable];
        btn.delegate=self.delegate;
    }
    
}

@end
