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


//-(id)init {
//
//    self = [super init];
//    if (self) {
//        
//        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isDBLoaded"] != 1)
//        {
//            [self CopyDbToDocumentsFolder];
//            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isDBLoaded"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        
//        return self;
//    }
//    return nil;
//}

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
    
    //insert
    sqltemp = @"Insert into Subject(SubjectName, AssetUrl) Values(";
    sqltemp = [sqltemp stringByAppendingFormat:@"'%@','%@')",@"Something",@"assetUrl.png"];
    const char *sql = [sqltemp UTF8String];
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    int result = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
}

-(void)InsertRecords:(NSString *) txt {
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    NSString *sqltemp;
    
    //insert
    sqltemp = @"Insert into SearchTerms(SearchTerm) Values('";
    sqltemp = [sqltemp stringByAppendingFormat:@"%@%@",txt, @"')"];
    const char *sql = [sqltemp UTF8String];
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"YardLinesDB.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
}


-(void)DeleteRecords{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;

    const char *sql = "Delete from SearchTerms";
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"YardLinesDB.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
}


//-(void)UpdateRecords:(NSString *)txt :(NSMutableString *)utxt{
//    
//    fileMgr = [NSFileManager defaultManager];
//    sqlite3_stmt *stmt=nil;
//    sqlite3 *cruddb;
//    
//    
//    //insert
//    const char *sql = "Update SearchTerms set coltext=? where coltext=?";
//    
//    //Open db
//    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"YardLinesDB.sqlite"];
//    sqlite3_open([cruddatabase UTF8String], &cruddb);
//    sqlite3_prepare_v2(cruddb, sql, 1, &stmt, NULL);
//    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(stmt, 2, [utxt UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_step(stmt);
//    sqlite3_finalize(stmt);
//    sqlite3_close(cruddb);
//    
//}


@end
