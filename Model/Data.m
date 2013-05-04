

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

-(QuizPage *)getQuizAtQuizId:(NSInteger)index {
    
    NSMutableArray *quizzes = [[CrudOp sharedDB] GetRecords:DBTableQuiz where:[NSString stringWithFormat:@"QuizId=%d",index]];

    return [quizzes objectAtIndex:0];
}

-(NSMutableArray *)getQuizOptionsForQuizId:(NSInteger)index {
    
    return [[CrudOp sharedDB] GetRecords:DBTableQuizOption where:[NSString stringWithFormat:@"QuizId=%d",index]];
}

-(NSInteger)saveSubject:(Subject *)sub {

    if(sub.subjectId!=0){
        [[CrudOp sharedDB] UpdateRecordForTable:DBTableSubject withObject:sub];
        return sub.subjectId;
    }
    else{
        [[CrudOp sharedDB] InsertRecordInTable:DBTableSubject withObject:sub];
        return [[CrudOp sharedDB] getIdentiyFromTable:DBTableSubject];
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
            if([option.videoUrl isEqualToString:@""] || option.videoUrl==nil || [option.assetUrl isEqualToString:@""])
                return FALSE;
        }
    }

    return YES;
}

-(NSInteger)saveQuiz:(QuizPage *)quizPage {
    
    if(quizPage.quizId==0){
        [[CrudOp sharedDB] InsertRecordInTable:DBTableQuiz withObject:quizPage];
        return [[CrudOp sharedDB] getIdentiyFromTable:DBTableQuiz];
    }
    else{
        [[CrudOp sharedDB] UpdateRecordForTable:DBTableQuiz withObject:quizPage];
        return quizPage.quizId;
    }
}

-(void)deleteQuizWithQuizId:(NSInteger)index {
    
    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableQuizOption where:[@"" stringByAppendingFormat:@"QuizId=%d",index]];
    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableQuiz withId:index];
}

-(NSInteger)saveQuizOption:(QuizOption *)quizOption {
    
    if(quizOption.quizOptionId==0) {
        [[CrudOp sharedDB] InsertRecordInTable:DBTableQuizOption withObject:quizOption];
        return [[CrudOp sharedDB] getIdentiyFromTable:DBTableQuizOption];
    }
    else{
        [[CrudOp sharedDB] UpdateRecordForTable:DBTableQuizOption withObject:quizOption];
        return quizOption.quizOptionId;
    }
}

-(void)deleteQuizOptionWithId:(NSInteger)index {
    
    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableQuizOption withId:index];
}

-(NSMutableArray *)getParameter:(NSString *)name{
    return [[CrudOp sharedDB] GetRecords:DBTableParameter where:[NSString stringWithFormat:@"Key='%@'",name]];
}

-(void)insertParameter:(NSString *)name withValue:(NSString *)value description:(NSString *)desc {
    [[CrudOp sharedDB] InsertRecordInTable:DBTableParameter withObject:[NSMutableArray arrayWithObjects:name,value,desc, nil]];
}

@end
