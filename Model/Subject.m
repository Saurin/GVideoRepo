//
//  Subject.m
//  GuidedVideo
//
//  Created by Mark Wade on 12/16/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import "Subject.h"
#import "Data.h"

@implementation Subject

@synthesize subjectId;
@synthesize subjectName;
@synthesize assetUrl;
@synthesize quizPages;

- (id)init
{
    self = [super init];
    if (self) {

        
        
        return self;
    }
    return nil;
}

-(id)copy
{
    Subject *object = [[Subject alloc] init];
    object.subjectId=self.subjectId;
    object.subjectName=self.subjectName;
    object.assetUrl=self.assetUrl;
    
    return object;
}

-(BOOL)isEqual:(Subject *)object {

    if (object==nil) {
        return FALSE;
    }
    
    if(self.subjectId!=object.subjectId
       || ![self.subjectName isEqualToString:object.subjectName]
       || ![self.assetUrl isEqualToString:object.assetUrl]){
        
        return FALSE;
    }
    else{
        return TRUE;
    }
}

@end
