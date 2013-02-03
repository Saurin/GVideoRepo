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
    
//    //get quiz pages for each subject
//    for (NSInteger i=0; i<mArray.count; i++) {
//        Subject *sub = [mArray objectAtIndex:i];
//        sub.quizPages = [[CrudOp sharedDB] GetRecords:DBTableQuiz where:[NSString stringWithFormat: @"SubjectId=%d",sub.subjectId]];
//    }

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

-(void)deleteSubject:(Subject *)sub {

    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableSubject withId:sub.subjectId];
}

-(void)saveQuiz:(QuizPage *)quizPage {
    if(quizPage.quizId==0)
        [[CrudOp sharedDB] InsertRecordInTable:DBTableQuiz withObject:quizPage];
    else
        [[CrudOp sharedDB] UpdateRecordForTable:DBTableQuiz withObject:quizPage];
}

-(void)saveQuizOption:(QuizOption *)quizOption {
    
    if(quizOption.quizOptionId==0)
       [[CrudOp sharedDB] InsertRecordInTable:DBTableQuizOption withObject:quizOption];
    else
        [[CrudOp sharedDB] UpdateRecordForTable:DBTableQuizOption withObject:quizOption];
}



@end
