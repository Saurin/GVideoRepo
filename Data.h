//
//  Data.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 1/20/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrudOp.h"
#import "Subject.h"
#import "Quiz.h"

@interface Data : NSObject

+ (Data *)sharedData;
-(NSMutableArray *)getSubjects;
-(Subject *)getSubjectAtIndex:(NSInteger)index;
- (void)saveSubjectAtIndex:(NSInteger)index subject:(Subject *)sub;
- (void)deleteSubjectAtIndex:(NSInteger)index;
-(void)addQuizAtIndex:(NSInteger)index forSubjectAtIndex:(NSInteger)subIndex quiz:(Quiz *)quiz;

@end
