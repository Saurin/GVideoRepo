//
//  Subject.h
//  GuidedVideo
//
//  Created by Mark Wade on 12/16/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Subject : NSObject <NSCopying>

@property BOOL isAddButton;
@property (nonatomic) NSInteger subjectId;
@property (nonatomic, strong) NSString * subjectName;
@property (nonatomic, strong) NSString * assetUrl;
@property (nonatomic, strong) NSMutableArray *quizPages;

-(id)copy;
-(BOOL)isEqual:(Subject *)object;
@end
