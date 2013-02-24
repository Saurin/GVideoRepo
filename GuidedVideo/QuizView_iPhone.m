
#import "QuizView_iPhone.h"
#import "CustomButton.h"
#import "QuizPage.h"

#define ButtonCount 6
#define VPadding 5
#define HPadding 5


@implementation QuizView_iPhone

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
    
    NSInteger buttonCount = ButtonCount/2;
    double buttonHeight = (self.frame.size.height-VPadding*(buttonCount+1))/buttonCount;
    double buttonWidth = (self.frame.size.width*.6-HPadding*(buttonCount+1))/buttonCount;
    
    
    NSInteger height = self.frame.size.height-VPadding*2;
    NSInteger width = self.frame.size.width*.4-HPadding*2;
    
    CGRect frame = CGRectMake(HPadding, VPadding, width, height);
    CustomButton *videoButton = [[CustomButton alloc] initWithFrame:frame];
    videoButton.tag=101;
    [self addSubview:videoButton];

    
    
    NSInteger tag=1,x=1,y=1;
    for(NSInteger i=0;i<ButtonCount;i++){
        
        CGRect frame = CGRectMake(HPadding*x+buttonWidth*(x-1)+width+HPadding,VPadding*y+buttonHeight*(y-1), buttonWidth, buttonHeight);

        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self addSubview:btn];
        [btn setHidden:YES];
        
        btn.delegate=self.delegate;
        
        y++;
        if(y==4){
            y=1;
            x++;
        }
    }

}

@end
