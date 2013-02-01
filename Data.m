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
        
        //[shardData getContent];
        return shardData;
    }
}


-(NSMutableArray *)getSubjects {
    NSMutableArray *mArray = [[CrudOp sharedDB] GetRecords:DBTableSubject];
    return mArray;
}


-(Subject *)getSubjectAtIndex:(NSInteger)index {
    
    NSMutableArray *allSubjects = [self getSubjects];
    for(NSInteger i=0;i<allSubjects.count;i++){
        Subject *sub = (Subject *)[allSubjects objectAtIndex:i];
        if(sub.subjectId==index){
            return sub;
        }
    }
    
    return nil;
}


-(void)saveSubjectAtIndex:(NSInteger)index subject:(Subject *)sub {
    
    if([self getSubjectAtIndex:index]){
        sub.subjectId=index;
        [[CrudOp sharedDB] UpdateRecordForTable:DBTableSubject withObject:sub];
    }
    else{
        [[CrudOp sharedDB] InsertRecordInTable:DBTableSubject withObject:sub];
    }
}


-(void)deleteSubjectAtIndex:(NSInteger)index {
    
    [[CrudOp sharedDB] DeleteRecordFromTable:DBTableSubject withId:index];

}


- (void) getContent{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/GuidedVideo.json",documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    
    if (data != nil) {
        subjects = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    }
}






-(NSString *)getQuizzesJSONFromSubect:(Subject *)sub {

    if(sub.quizzes==nil)
        return @"";
    

    NSMutableArray *myMutableArray = [[NSMutableArray alloc] init];
    for(NSInteger i=0;i<sub.quizzes.count;i++){
        
        Quiz *quiz = [sub.quizzes objectAtIndex:i];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              quiz.videoUrl,@"videoUrl"
                              ,[self getAssetsJSONFromQuiz:quiz],@"assetUrls"
                              ,nil];
        [myMutableArray addObject:dict];
    }
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:myMutableArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return content;
}

-(NSString *)getAssetsJSONFromQuiz:(Quiz *)quiz {
    
    if(quiz.assetUrls==nil)
        return @"";
    
    NSMutableArray *myMutableArray = [[NSMutableArray alloc] init];
    for(NSInteger i=0;i<quiz.assetUrls.count;i++){
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [quiz.assetUrls objectAtIndex:i],@"assetUrl"
                              ,nil];
        [myMutableArray addObject:dict];
    }
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:myMutableArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return content;
}

-(void)addQuizAtIndex:(NSInteger)index forSubjectAtIndex:(NSInteger)subIndex quiz:(Quiz *)quiz {

    Subject *sub = [self getSubjectAtIndex:subIndex];
    if(sub.quizzes==nil)
        sub.quizzes = [[NSMutableArray alloc] init];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          quiz.videoUrl,@"videoUrl"
                          ,nil];

    [sub.quizzes addObject:dict];                                   //adding a new quiz in existing
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:sub.quizzes options:NSJSONWritingPrettyPrinted error:&error];
    NSString *content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    //get subject node, and update quizzes
    NSDictionary *subDict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sub.subjectName,@"subjectName"
                          ,sub.assetUrl, @"assetUrl"
                          ,content,@"quizzes"
                          ,nil];
    NSMutableArray *myMutableArray = [NSMutableArray arrayWithArray:subjects];
    [myMutableArray replaceObjectAtIndex:subIndex withObject:subDict];
    [self updateJSON:myMutableArray];
    

}



-(void)updateJSON:(NSMutableArray *)myMutableArray {
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:myMutableArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"JSON String: %@", content);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/GuidedVideo.json", documentsDirectory];
    //save content to the documents directory
    [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    //get a new array now
    [self getContent];
}

@end
