

#import <Foundation/Foundation.h>

@protocol SelectionChangeDelegate <NSObject>

@optional
-(void)didSubjectChange:(Subject *)newSubject;
-(void)didQuizChange:(QuizPage *)newQuiz;

@end
