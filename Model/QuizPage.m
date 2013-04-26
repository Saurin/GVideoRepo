
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

- (id)initWithSubjectId:(NSInteger)subId name:(NSString *)name videoURL:(NSString *)videoURL
{
    self = [super init];
    if (self) {
        
        subjectId=subId;
        quizName=name;
        videoUrl=videoURL;
        
        return self;
        
    }
    return nil;
}

-(id)copy
{
    QuizPage *object = [[QuizPage alloc] init];
    object.quizId=self.quizId;
    object.subjectId=self.subjectId;
    object.quizName=self.quizName;
    object.quizOptions=self.quizOptions;
    object.videoUrl=self.videoUrl;
    
    return object;
}

-(BOOL)isEqual:(QuizPage *)object {
    
    if (object==nil) {
        return FALSE;
    }
    
    if(self.subjectId==object.subjectId
       && self.quizId==object.quizId
       && [self.quizName isEqualToString:object.quizName]
       && [self.videoUrl isEqualToString:object.videoUrl]){
        
        return TRUE;
    }
    else{
        return FALSE;
    }
}

@end
