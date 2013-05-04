
#import <Foundation/Foundation.h>
#import "CrudOp.h"
#import "Subject.h"
#import "QuizPage.h"
#import "QuizOption.h"

@interface Data : NSObject

+ (Data *)sharedData;
-(NSMutableArray *)getSubjects;
    
-(Subject *)getSubjectAtSubjectId:(NSInteger)index;
-(NSMutableArray *)getQuizOptionsForQuizId:(NSInteger)index;
-(QuizPage *)getQuizAtQuizId:(NSInteger)index;

- (NSInteger)saveSubject:(Subject *)sub;
- (void)deleteSubjectWithSubjectId:(NSInteger)index;
- (BOOL)isSubjectProgrammed:(NSInteger)index;

-(NSInteger)saveQuiz:(QuizPage *)quizPage;
-(void)deleteQuizWithQuizId:(NSInteger)index;

-(NSInteger)saveQuizOption:(QuizOption *)quizOption;
-(void)deleteQuizOptionWithId:(NSInteger)index;

-(NSMutableArray *)getParameter:(NSString *)name;
-(void)insertParameter:(NSString *)name withValue:(NSString *)value description:(NSString *)desc;
@end
