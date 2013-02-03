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

- (void)saveSubject:(Subject *)sub;
- (void)deleteSubject:(Subject *)sub;

-(void)saveQuiz:(QuizPage *)quizPage;
-(void)saveQuizOption:(QuizOption *)quizOption;

@end
