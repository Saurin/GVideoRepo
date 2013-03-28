
#import <Foundation/Foundation.h>

@interface QuizPage : NSObject

@property (nonatomic) NSInteger subjectId;
@property (nonatomic) NSInteger quizId;
@property (nonatomic) NSInteger quizName;
@property (nonatomic, strong) NSMutableArray* quizOptions;
@property (nonatomic, strong) NSString * videoUrl;

@end
