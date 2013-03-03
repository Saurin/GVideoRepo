
#import "QuizView_iPad.h"
#import "CustomButton.h"
#import "QuizPage.h"

#define ButtonCount 12
#define VPadding 20
#define HPadding 40


@implementation QuizView_iPad {
    
}

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
    
    for (UIView* v in self.subviews) {
        [v removeFromSuperview];
    }
    
    
    NSInteger tag=1;
    NSInteger buttonCount = ButtonCount/4+1;
    double buttonHeight = (self.frame.size.height-VPadding*(buttonCount+1))/buttonCount;
    double buttonWidth = (self.frame.size.width-HPadding*(buttonCount+1))/buttonCount;
    
    //bottom row
    for(NSInteger i=0;i<4;i++){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, self.frame.size.height-buttonHeight-VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];

        BOOL isEditable=NO;
        if([self.delegate respondsToSelector:@selector(isEditableButtonAtTag:)])
            isEditable = [self.delegate isEditableButtonAtTag:btn.tag];
        
        [btn setEditable:isEditable];

        btn.delegate=self;
        
    }
    
    //right column
    for(NSInteger i=2;i>0;i--){
        
        CGRect frame = CGRectMake(self.frame.size.width-buttonWidth-HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];

        BOOL isEditable=NO;
        if([self.delegate respondsToSelector:@selector(isEditableButtonAtTag:)])
            isEditable = [self.delegate isEditableButtonAtTag:btn.tag];
        
        [btn setEditable:isEditable];
        btn.delegate=self;
    }
    
    
    //top row
    for(NSInteger i=3;i>=0;i--){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];
        BOOL isEditable=NO;
        if([self.delegate respondsToSelector:@selector(isEditableButtonAtTag:)])
            isEditable = [self.delegate isEditableButtonAtTag:btn.tag];
        
        [btn setEditable:isEditable];
        btn.delegate=self;
    }
    
    //left column
    for(NSInteger i=1;i<=2;i++){
        
        CGRect frame = CGRectMake(HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];
        BOOL isEditable=NO;
        if([self.delegate respondsToSelector:@selector(isEditableButtonAtTag:)])
            isEditable = [self.delegate isEditableButtonAtTag:btn.tag];
        
        [btn setEditable:isEditable];
        btn.delegate=self;
    }
    
    NSInteger height = self.frame.size.height-buttonHeight*2-VPadding*4;
    NSInteger width = self.frame.size.width-buttonWidth*2-HPadding*4;
    
    CGRect frame = CGRectMake((self.frame.size.width-width)/2, (self.frame.size.height-height)/2, width, height);
    CustomButton *videoButton = [[CustomButton alloc] initWithFrame:frame];
    videoButton.tag=101;
    [self addSubview:videoButton];
    
}

@end
