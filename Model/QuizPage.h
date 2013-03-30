
#import <Foundation/Foundation.h>

@interface QuizPage : NSObject

@property (nonatomic) NSInteger subjectId;
@property (nonatomic) NSInteger quizId;
@property (nonatomic) NSString *quizName;
@property (nonatomic, strong) NSMutableArray* quizOptions;
@property (nonatomic, strong) NSString * videoUrl;
@property (nonatomic, strong) UIImage *imgThumb;

-(id)copy;
-(BOOL)isEqual:(QuizPage *)object;

@end
