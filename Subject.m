//
//  Subject.m
//  GuidedVideo
//
//  Created by Mark Wade on 12/16/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import "Subject.h"


@implementation Subject

@synthesize isAddButton;
@synthesize subjectId;
@synthesize subjectName;
@synthesize assetUrl;
@synthesize quizzes;

- (id)init
{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

@end
