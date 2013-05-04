//
//  QuizOption.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "QuizOption.h"

@implementation QuizOption

- (id)init
{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

- (id)initWithQuizId:(NSInteger)quizId optionName:(NSString *)name optionImageUrl:(NSString *)imgURL
{
    self = [super init];
    if (self) {
        
        self.quizId=quizId;
        self.assetName = name;
        self.assetUrl = imgURL;
        return self;
    }
    return nil;
}


-(id)copy
{
    QuizOption *object = [[QuizOption alloc] init];
    object.quizId=self.quizId;
    object.quizOptionId=self.quizOptionId;
    object.assetUrl=self.assetUrl;
    object.videoUrl=self.videoUrl;
    object.response=self.response;
    object.assetName=self.assetName;
    
    return object;
}

-(BOOL)isEqual:(QuizOption *)object {
    
    if (object==nil) {
        return FALSE;
    }
    
    if(self.quizOptionId==object.quizOptionId
       && self.quizId==object.quizId
       && [self.assetUrl isEqualToString:object.assetUrl]
       && [self.videoUrl isEqualToString:object.videoUrl]
       && self.response==object.response
       && [self.assetName isEqualToString:object.assetName]){
        
        return TRUE;
    }
    else{
        return FALSE;
    }
}
           
@end
