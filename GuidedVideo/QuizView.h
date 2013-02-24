

#import <UIKit/UIKit.h>


@interface QuizView : UIView

@property (nonatomic, readwrite, assign) IBOutlet id delegate;

-(void)redraw;

@end
