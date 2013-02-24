
#import <Foundation/Foundation.h>


@interface QuizPage : NSObject

@property (nonatomic) NSInteger subjectId;
@property (nonatomic) NSInteger quizId;
@property (nonatomic, retain) NSMutableArray* quizOptions;
@property (nonatomic, retain) NSString * videoUrl;

@end
