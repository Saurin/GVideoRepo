

#import "QuizView.h"
#import "CustomButton.h"

@interface QuizView_iPad : QuizView<AddSubjectDelegate>

@property (nonatomic, readwrite, assign) IBOutlet id delegate;

-(void)redraw;

@end
