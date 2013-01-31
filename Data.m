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

    

//    if(subjects!=nil)
//    {
//    if(subjects!=nil && [subjects count]>index) {
//        NSDictionary *item = [subjects objectAtIndex:index];
//        Subject *subject = [[Subject alloc] init];
//        subject.subjectName = [item objectForKey:@"subjectName"];
//        subject.assetUrl = [item objectForKey:@"assetUrl"];
//        subject.quizzes = [[NSMutableArray alloc] init];
//        
//        NSString *quizzes = [item objectForKey:@"quizzes"];
//        if(![quizzes isEqualToString:@""]){
//            NSError *error;
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [quizzes dataUsingEncoding:NSUTF8StringEncoding]
//                                                                 options: NSJSONReadingMutableContainers
//                                                                   error: &error];
//            for (id obj in dict) {
//                
//                Quiz *quiz = [[Quiz alloc] init];
//                quiz.videoUrl=[obj objectForKey:@"videoUrl"];
//                
//                NSString *assests = [item objectForKey:@"assetUrls"];
//                if(![assests isEqualToString:@""]){
//                    NSError *error;
//                    NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData: [assests dataUsingEncoding:NSUTF8StringEncoding]
//                                                                          options: NSJSONReadingMutableContainers
//                                                                            error: &error];
//                    quiz.assetUrls = [[NSMutableArray alloc] init];
//                    for(id obj in dict1){
//                        [quiz.assetUrls addObject:[item objectForKey:@"assetUrl"]];
//                    }
//                }
//                [subject.quizzes addObject:quiz];
//            }
//        }
//        return subject;
//    }
//    else {
//        //throw error
//        
//        return nil;
//    }
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




- (void)saveSubjectAtIndex:(NSInteger)index subject:(Subject *)sub {
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sub.subjectName,@"subjectName"
                          ,sub.assetUrl, @"assetUrl"
                          ,[self getQuizzesJSONFromSubect:sub],@"quizzes"
                          ,nil];
    NSMutableArray *myMutableArray = [NSMutableArray arrayWithArray:subjects];
    
    //add a new subject into existing array
    if(index>=[subjects count]){
        
        [myMutableArray addObject:dict];
    }
    else{
    
        [myMutableArray replaceObjectAtIndex:index withObject:dict];
    }
    
    [self updateJSON:myMutableArray];
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

-(void)deleteSubjectAtIndex:(NSInteger)index {
    
    if (subjects==nil) {
        [self getContent];
    }
    
    if(subjects!=nil && [subjects count]>index) {
        
        NSMutableArray *newMutableArray = [NSMutableArray arrayWithArray:subjects];
        [newMutableArray removeObjectAtIndex:index];
        subjects = [NSArray arrayWithArray:newMutableArray];
        
        [self updateJSON:newMutableArray];
    }
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
