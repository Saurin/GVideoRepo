//
//  CrudOp.h
//  YardLines
//
//  Created by June Lee on 9/28/12.
//  Copyright (c) 2012 Insurance Auto Auctions, INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Subject.h"
#import "QuizPage.h"
#import "QuizOption.h"

typedef NS_ENUM(NSInteger, TableName) {
    DBTableSubject = 0,
    DBTableQuiz=1,
    DBTableQuizOption
};

@interface CrudOp : NSObject <UIAlertViewDelegate> {
    NSInteger dataId;
    NSString *coltext;
    NSInteger colint;
    double coldbl;
    sqlite3 *db;
    NSFileManager *fileMgr;
    NSString *homeDir;
    NSString *title;
    NSMutableArray *searchTerms;
}

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *coltext;
@property (nonatomic,retain) NSString *homeDir;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic,assign) NSInteger colint;
@property (nonatomic, assign) double coldbl;
@property (nonatomic,retain) NSFileManager *fileMgr;

+ (CrudOp *)sharedDB;

-(NSMutableArray*)GetRecords:(TableName)table where:(NSString*)filter;
-(void)InsertRecordInTable:(TableName)table withObject:(id)obj;
-(void)DeleteRecordFromTable:(TableName)table withId:(NSInteger)index;
-(void)DeleteRecordFromTable:(TableName)table where:(NSString *)where;
-(void)UpdateRecordForTable:(TableName)table withObject:(id)obj;

@end
