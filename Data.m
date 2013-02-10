//
//  Data.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 1/20/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "Data.h"
#import <Foundation/NSJSONSerialization.h>

@implementation Data {
    NSArray *subjects;
}

+ (Data *)sharedData {
    static Data *shardData = nil;
    
    @synchronized(self)
    {
        if (!shardData)
            shardData = [[Data alloc] init];
        
        return shardData;
    }
}

-(NSMutableArray *)getSubjects {
    
    NSMutableArray *mArray = [[CrudOp sharedDB] GetRecords:DBTableSubject where:@""];
    return mArray;
}

-(Subject *)getSubjectAtSubjectId:(NSInteger)index {
    
    NSMutableArray *subejcts = [[CrudOp sharedDB] GetRecords:DBTableSubject where:[NSString stringWithFormat: @"SubjectId=%d",index]];
    if(subejcts==nil || subejcts.count==0)
        return nil;
    
    Subject *sub=[subejcts objectAtIndex:0];
    
    NSMutableArray *quizzes = [[CrudOp sharedDB] GetRecords:DBTableQuiz where:[NSString stringWithFormat:@"SubjectId=%d",index]];
    sub.quizPages = quizzes;
    
    return sub;
}

-(NSMutableArray *)getQuizOptionsForQuizId:(NSInteger)index {
    
    return [[CrudOp sharedDB] GetRecords:DBTableQuizOption where:[NSString stringWithFormat:@"QuizId=%d",index]];
}

-(void)saveSubject:(Subject *)sub {

    if([self getSubjectAtSubjectId:sub.subjectId]){
        [[CrudOp sharedDB] UpdateRecordForTable:DBTableSubject withObject:sub];
    }
    else{
        [[CrudOp sharedDB] InsertRecordInTable:DBTableSubject withObject:sub];
    }
}

-(void)deleteSubjectWithSubjectId:(NSInteger)index {

    //get all quizzes for this subject
    NSMutableArray *data = [[CrudOp sharedDB] GetRecords:DBTableQuiz where:[@"" stringByAppendingFormat:@"SubjectId=%d",index]];
    for (NSInteger i=0; i<data.count; i++) {
        
        QuizPage *quiz = [data objectAtIndex:i];
        [[CrudOp sharedDB] DeleteRecordFromTable:DBTableQuizOption where:[@"" stringByAppendingFormat:@"QuizId=%d",quiz.quizId]];
    }
    
    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableQuiz where:[@"" stringByAppendingFormat:@"SubjectId=%d",index]];
    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableSubject withId:index];
}

- (BOOL)isSubjectProgrammed:(NSInteger)index {
    
    NSMutableArray *quizzes = [[CrudOp sharedDB] GetRecords:DBTableQuiz where:[@"" stringByAppendingFormat:@"SubjectId=%d",index]];
    
    //atleast should have one quiz defined
    if(quizzes==nil || quizzes.count==0)
        return FALSE;

    for (NSInteger i=0; i<quizzes.count; i++) {
        //each quiz should have atleast one complete button
        QuizPage *quiz = [quizzes objectAtIndex:i];
        NSMutableArray *quizOptions = [[CrudOp sharedDB] GetRecords:DBTableQuizOption where:[@"" stringByAppendingFormat:@"QuizId=%d",quiz.quizId]];
        
        //every quiz option should have
        if(quizOptions==nil || quizOptions.count==0)
            return FALSE;

        //each option added for quiz should have photo & video
        for(NSInteger j=0;j<quizOptions.count;j++){
            QuizOption *option = [quizOptions objectAtIndex:j];
            if([option.videoUrl isEqualToString:@""] || [option.assetUrl isEqualToString:@""])
                return FALSE;
        }
    }

    return YES;
}

-(void)saveQuiz:(QuizPage *)quizPage {
    
    if(quizPage.quizId==0)
        [[CrudOp sharedDB] InsertRecordInTable:DBTableQuiz withObject:quizPage];
    else
        [[CrudOp sharedDB] UpdateRecordForTable:DBTableQuiz withObject:quizPage];
}

-(void)deleteQuizWithQuizId:(NSInteger)index {
    
    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableQuizOption where:[@"" stringByAppendingFormat:@"QuizId=%d",index]];
    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableQuiz withId:index];
}

-(void)saveQuizOption:(QuizOption *)quizOption {
    
    if(quizOption.quizOptionId==0)
       [[CrudOp sharedDB] InsertRecordInTable:DBTableQuizOption withObject:quizOption];
    else
        [[CrudOp sharedDB] UpdateRecordForTable:DBTableQuizOption withObject:quizOption];
}

-(void)deleteQuizOptionWithId:(NSInteger)index {
    
    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableQuizOption withId:index];
}


@end
