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
#import "QuizPage.h"
#import "QuizOption.h"

@interface Data : NSObject

+ (Data *)sharedData;
-(NSMutableArray *)getSubjects;
    
-(Subject *)getSubjectAtSubjectId:(NSInteger)index;
-(NSMutableArray *)getQuizOptionsForQuizId:(NSInteger)index;
-(QuizPage *)getQuizAtQuizId:(NSInteger)index;

- (NSInteger)saveSubject:(Subject *)sub;
- (void)deleteSubjectWithSubjectId:(NSInteger)index;
- (BOOL)isSubjectProgrammed:(NSInteger)index;

-(NSInteger)saveQuiz:(QuizPage *)quizPage;
-(void)deleteQuizWithQuizId:(NSInteger)index;

-(NSInteger)saveQuizOption:(QuizOption *)quizOption;
-(void)deleteQuizOptionWithId:(NSInteger)index;

@end
