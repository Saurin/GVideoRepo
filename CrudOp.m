//
//  CrudOp.m
//  YardLines
//
//  Created by June Lee on 9/28/12.
//  Copyright (c) 2012 Insurance Auto Auctions, INC. All rights reserved.
//

#import "CrudOp.h"

@implementation CrudOp
@synthesize  coldbl;
@synthesize colint;
@synthesize coltext;
@synthesize dataId;
@synthesize fileMgr;
@synthesize homeDir;
@synthesize title;


+ (CrudOp *)sharedDB
{
    static CrudOp *sharedDB = nil;
    
    @synchronized(self)
    {
        if (!sharedDB)
            sharedDB = [[CrudOp alloc] init];
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isDBLoaded"] != 1)
        {
            [sharedDB CopyDbToDocumentsFolder];
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isDBLoaded"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        return sharedDB;
    }
}

-(void)CopyDbToDocumentsFolder{
    NSError *err=nil;
    
    fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DB.sqlite"];
    
    NSString *copydbpath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
    
    [fileMgr removeItemAtPath:copydbpath error:&err];
    if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err])
    {
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to copy database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tellErr show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    exit(0);
}

-(NSString *)GetDocumentDirectory{
    
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}

-(NSMutableArray*)GetRecords:(TableName)table {
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    NSMutableArray *myMutuableArray = [[NSMutableArray alloc] init];
    NSString *sqltemp;
    
    
    if(table==DBTableSubject){
        sqltemp = @"Select SubjectId, SubjectName, AssetUrl From Subject order by 1 asc";
        const char *sql = [sqltemp UTF8String];
    
        //Open db
        NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
        if(sqlite3_open([cruddatabase UTF8String], &cruddb)!=SQLITE_OK)
            NSLog(@"FAILED TO OPEN DB");

        int result = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
        if(result!=SQLITE_OK)
            NSLog(@"FAILED TO PREPARE STMT");
        
        while(sqlite3_step(stmt)== SQLITE_ROW)
        {
            Subject *sub = [[Subject alloc] init];
            sub.subjectId=sqlite3_column_int(stmt, 0);
            
            if(sqlite3_column_text(stmt, 1)!=nil)
                sub.subjectName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            if(sqlite3_column_text(stmt, 2)!=nil)
                sub.assetUrl=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            
            [myMutuableArray addObject:sub];
        }
        
    }
    else if (table==DBTableQuiz){
        
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
    return myMutuableArray;
}

-(void)InsertRecordInTable:(TableName)table withObject:(id)obj {

    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    NSString *sqltemp;
    
    const char *sql;
    if(table==DBTableSubject){
        
        Subject *sub = obj;
        
        sqltemp = @"Insert into Subject(SubjectName, AssetUrl) Values(";
        sqltemp = [sqltemp stringByAppendingFormat:@"'%@','%@')",sub.subjectName,sub.assetUrl];
    }
    else if(table==DBTableQuiz){
        
    }
    
    sql = [sqltemp UTF8String];
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    int result = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    if(result!=SQLITE_OK)
        NSLog(@"FAILED TO PREPARE STMT");
    sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
}

-(void)DeleteRecordFromTable:(TableName)table withId:(NSInteger)index {
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    NSString *sqltemp;
    
    const char *sql;
    if(table==DBTableSubject)
        sqltemp = [NSString stringWithFormat:@"Delete from Subject where SubjectId=%d",index];
    else if(table==DBTableQuiz)
        sqltemp = [NSString stringWithFormat:@"Delete from Subject where SubjectId=%d",index];
    
    sql = [sqltemp UTF8String];
    
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    int result = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    if(result!=SQLITE_OK)
        NSLog(@"FAILED TO PREPARE STMT");
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
}


-(void)UpdateRecordForTable:(TableName)table withObject:(id)obj {
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    const char *sql;
    NSString *sqltemp;

    if(table==DBTableSubject){
        Subject *sub = obj;
        sqltemp = [NSString stringWithFormat:@"Update Subject set SubjectName='%@', AssetUrl='%@' where SubjectId=%d",sub.subjectName,sub.assetUrl, sub.subjectId];
    }
    else if(table==DBTableQuiz)
        sqltemp = [NSString stringWithFormat:@"Update Subject set SubjectName='%@', AssetUrl='%@' where SubjectId=%d",@"",@"",0];
    
    sql = [sqltemp UTF8String];
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    int result = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    if(result!=SQLITE_OK)
        NSLog(@"FAILED TO PREPARE STMT");
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
}


@end
