//
//  Subject.h
//  GuidedVideo
//
//  Created by Mark Wade on 12/16/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Subject : NSObject

@property BOOL isAddButton;
@property (nonatomic) NSInteger subjectId;
@property (nonatomic, retain) NSString * subjectName;
@property (nonatomic, retain) NSString * assetUrl;
@property (nonatomic, retain) NSMutableArray* quizzes;


@end
