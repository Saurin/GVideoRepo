//
//  QuizPage.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizPage : NSObject

@property (nonatomic) NSInteger subjectId;
@property (nonatomic) NSInteger quizId;
@property (nonatomic, retain) NSMutableArray* quizOptions;
@property (nonatomic, retain) NSString * videoUrl;

@end
