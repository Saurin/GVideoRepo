

#import <UIKit/UIKit.h>
#import "OHAlertView.h"

@interface Message : OHAlertView

-(id)initSubjectIncompleteMessageWithTitle:(NSString *)title cancelButtonTitle:(NSString *)text;
-(id)initInstructionIncompleteMessageWithTitle:(NSString *)title cancelButtonTitle:(NSString *)text;
-(id)initAlternativeIncompleteMessageWithTitle:(NSString *)title cancelButtonTitle:(NSString *)text;

@end
