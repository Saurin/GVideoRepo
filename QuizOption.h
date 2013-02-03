//
//  QuizOption.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizOption : NSObject

@property (nonatomic) NSInteger quizOptionId;
@property (nonatomic) NSInteger quizId;
@property (nonatomic, retain) NSString* assetUrl;

@end
