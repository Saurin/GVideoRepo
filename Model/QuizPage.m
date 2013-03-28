
#import "QuizPage.h"

@implementation QuizPage

@synthesize subjectId;
@synthesize quizId;
@synthesize quizName;
@synthesize quizOptions;
@synthesize videoUrl;

- (id)init
{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}


@end
