

#import "Message.h"

@implementation Message

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(id)initSubjectIncompleteMessageWithTitle:(NSString *)title cancelButtonTitle:(NSString *)text {
    
    self = (Message *) [[OHAlertView alloc] initWithTitle:@"" message:@"Please correct the followings..." delegate:nil cancelButtonTitle:text otherButtonTitles:nil, nil];

    if (self) {
        
        self.title = title;
        self.message = @"  Missing:\n  Subject image;\n  Instruction; or\n  Alternative";
        ((UILabel *)[self.subviews objectAtIndex:1]).textAlignment = NSTextAlignmentLeft;
   }
    
    return self;
}

-(id)initInstructionIncompleteMessageWithTitle:(NSString *)title cancelButtonTitle:(NSString *)text {
    
    self = (Message *) [[OHAlertView alloc] initWithTitle:@"" message:@"Please correct the followings..." delegate:nil cancelButtonTitle:text otherButtonTitles:nil, nil];
    
    if (self) {
        
        self.title = title;
        self.message = @"  Missing:\n  Instruction video; or\n  Alternative";
        ((UILabel *)[self.subviews objectAtIndex:1]).textAlignment = NSTextAlignmentLeft;
    }
    
    return self;
    
}

-(id)initAlternativeIncompleteMessageWithTitle:(NSString *)title cancelButtonTitle:(NSString *)text {

    self = (Message *) [[OHAlertView alloc] initWithTitle:@"" message:@"Please correct the followings..." delegate:nil cancelButtonTitle:text otherButtonTitles:nil, nil];
    
    if (self) {
        
        self.title = title;
        self.message = @"  Missing:\n  Alternative image; or\n  Alternative video";
        ((UILabel *)[self.subviews objectAtIndex:1]).textAlignment = NSTextAlignmentLeft;
    }
    
    return self;
    
}

@end
