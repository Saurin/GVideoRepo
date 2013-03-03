

#import <UIKit/UIKit.h>
#import "QuizViewDelegate.h"

@interface QuizView : UIView <QuizViewDelegate>

@property (nonatomic, readwrite, assign) IBOutlet id delegate;

-(void)redraw;

@end
