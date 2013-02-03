//
//  QuizPage.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "QuizPage.h"

@implementation QuizPage

@synthesize subjectId;
@synthesize quizId;
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
