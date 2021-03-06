

#import "CrudOp.h"

@implementation CrudOp

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
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to copy database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

-(NSMutableArray*)GetRecords:(TableName)table where:(NSString*)filter {
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    NSMutableArray *myMutuableArray = [[NSMutableArray alloc] init];
    
    const char *sql=[@"" UTF8String];
    if(table==DBTableSubject){
        
        NSString *sqltemp = @"Select SubjectId, SubjectName, AssetUrl From Subject ";
        if(![filter isEqualToString:@""]){
            sqltemp = [sqltemp stringByAppendingFormat:@" where %@",filter];
        }
        sqltemp = [sqltemp stringByAppendingFormat:@"%@",@" order by 1 asc"];
        
        sql = [sqltemp UTF8String];
    }
    else if(table==DBTableQuiz){

        NSString *sqltemp = @"Select QuizId, SubjectId, VideoUrl, QuizName From Quiz ";
        if(![filter isEqualToString:@""]){
            sqltemp = [sqltemp stringByAppendingFormat:@" where %@",filter];
        }
        sqltemp = [sqltemp stringByAppendingFormat:@"%@",@" order by 1 asc"];
        
        sql = [sqltemp UTF8String];
    }
    else if(table==DBTableQuizOption){

        NSString *sqltemp = @"Select Id, QuizId, AssetUrl, VideoUrl, Response, AssetName From QuizAsset ";
        if(![filter isEqualToString:@""]){
            sqltemp = [sqltemp stringByAppendingFormat:@" where %@",filter];
        }
        sqltemp = [sqltemp stringByAppendingFormat:@"%@",@" order by 1 asc"];
        
        sql = [sqltemp UTF8String];
    }
    else if(table==DBTableParameter){

        NSString *sqltemp = @"Select Id, Key, Value, Description From Parameter";
        if(![filter isEqualToString:@""]){
            sqltemp = [sqltemp stringByAppendingFormat:@" where %@",filter];
        }
        sqltemp = [sqltemp stringByAppendingFormat:@"%@",@" order by 1 asc"];
        
        sql = [sqltemp UTF8String];
    }
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
    if(sqlite3_open([cruddatabase UTF8String], &cruddb)!=SQLITE_OK)
        NSLog(@"FAILED TO OPEN DB");
    
    int result = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    if(result!=SQLITE_OK)
        NSLog(@"FAILED TO PREPARE STMT");
    
    
    if(table==DBTableSubject){
        
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
        
        while(sqlite3_step(stmt)== SQLITE_ROW)
        {
            QuizPage *quiz = [[QuizPage alloc] init];
            quiz.quizId=sqlite3_column_int(stmt, 0);
            quiz.subjectId=sqlite3_column_int(stmt, 1);
            
            if(sqlite3_column_text(stmt, 2)!=nil)
                quiz.videoUrl=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            if(sqlite3_column_text(stmt, 3)!=nil)
                quiz.quizName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];

            [myMutuableArray addObject:quiz];
        }
    }
    else if (table==DBTableQuizOption){
        
        while(sqlite3_step(stmt)== SQLITE_ROW)
        {
            QuizOption *option = [[QuizOption alloc] init];
            option.quizOptionId=sqlite3_column_int(stmt, 0);
            option.quizId=sqlite3_column_int(stmt, 1);
            
            if(sqlite3_column_text(stmt, 2)!=nil)
                option.assetUrl=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            if(sqlite3_column_text(stmt, 3)!=nil)
                option.videoUrl=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
            
            option.response=sqlite3_column_int(stmt, 4);
            
            if(sqlite3_column_text(stmt, 5)!=nil)
                option.assetName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
            
            [myMutuableArray addObject:option];
        }
    }
    else if(table==DBTableParameter){

        while(sqlite3_step(stmt)== SQLITE_ROW)
        {
            NSMutableArray *parameter = [[NSMutableArray alloc] initWithObjects:
                     [NSNumber numberWithInt:sqlite3_column_int(stmt, 0)]                           //id
                    ,[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)]           //key
                    ,[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)]           //value
                    ,[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)]           //description
                    ,nil];
            
            [myMutuableArray addObject:parameter];
        }
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
        
        QuizPage *quiz = obj;
        
        sqltemp = @"Insert into Quiz(SubjectId, VideoUrl, QuizName) Values(";
        sqltemp = [sqltemp stringByAppendingFormat:@"%d,'%@','%@')",quiz.subjectId, quiz.videoUrl, quiz.quizName];
    }
    else if(table==DBTableQuizOption){
        
        QuizOption *option = obj;

        if(option.videoUrl==nil || [option.videoUrl isEqualToString:@""]){

            sqltemp = @"Insert into QuizAsset(QuizId, AssetUrl, AssetName) Values (";
            sqltemp = [sqltemp stringByAppendingFormat:@"%d,'%@','%@')",option.quizId, option.assetUrl, option.assetName];
        }
        else{
            
            sqltemp = @"Insert into QuizAsset(QuizId, AssetUrl, VideoUrl, Response, AssetName) Values(";
            sqltemp = [sqltemp stringByAppendingFormat:@"%d,'%@','%@',%d,'%@')",option.quizId, option.assetUrl, option.videoUrl, option.response, option.assetName];
        }
    }
    else if(table==DBTableParameter){
        
        sqltemp = @"Insert into Parameter(Key, Value, Description) Values (";
        sqltemp = [sqltemp stringByAppendingFormat:@"'%@','%@','%@')",[obj objectAtIndex:0],[obj objectAtIndex:1],[obj objectAtIndex:2]];
    }
    
    sql = [sqltemp UTF8String];
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    int result = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    if(result!=SQLITE_OK)
        NSLog(@"FAILED TO PREPARE STMT");
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);        
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
        sqltemp = [NSString stringWithFormat:@"Delete from Quiz where QuizId=%d",index];
    else if(table==DBTableQuizOption)
        sqltemp = [NSString stringWithFormat:@"Delete from QuizAsset where Id=%d",index];
    
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

-(void)DeleteRecordFromTable:(TableName)table where:(NSString *)where {

    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    NSString *sqltemp;
    
    const char *sql;
    if(table==DBTableSubject)
        sqltemp = [NSString stringWithFormat:@"Delete from Subject where %@",where];
    else if(table==DBTableQuiz)
        sqltemp = [NSString stringWithFormat:@"Delete from Quiz where %@",where];
    else if(table==DBTableQuizOption)
        sqltemp = [NSString stringWithFormat:@"Delete from QuizAsset where %@", where];
    
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
    else if(table==DBTableQuiz) {
        QuizPage *quiz = obj;
        sqltemp = [NSString stringWithFormat:@"Update Quiz set VideoUrl='%@', QuizName='%@' where QuizId=%d",quiz.videoUrl,quiz.quizName,quiz.quizId];
    }
    else if(table==DBTableQuizOption){
        QuizOption *option = obj;
        sqltemp = [NSString stringWithFormat:@"Update QuizAsset set AssetUrl='%@', VideoUrl='%@', Response=%d, AssetName='%@' where Id=%d", option.assetUrl, option.videoUrl, option.response, option.assetName ,option.quizOptionId];
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

-(void)UpdateTable:(TableName)table set:(NSString *)set where:(NSString *)where {

    NSMutableArray *tables = [NSMutableArray arrayWithObjects:@"Subject",@"Quiz",@"QuizAsset", nil];
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    const char *sql;
    NSString *sqltemp;

    sqltemp = [@"" stringByAppendingFormat:@"Update %@ set %@ where %@",[tables objectAtIndex:table],set,where];
    sql = [sqltemp UTF8String];
    int result=sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    if(result!=SQLITE_OK)
        NSLog(@"FAILED TO PREPARE STMT");
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
}

-(BOOL)isColumnExist:(NSString *)columnName inTable:(TableName)table {
    
    NSMutableArray *tables = [NSMutableArray arrayWithObjects:@"Subject",@"Quiz",@"QuizAsset", nil];
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    const char *sql=[@"" UTF8String];
    
    NSString *sqltemp =  [@"pragma table_info(" stringByAppendingFormat:@"%@)",[tables objectAtIndex:table]];
    sql = [sqltemp UTF8String];
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
    if(sqlite3_open([cruddatabase UTF8String], &cruddb)!=SQLITE_OK)
        NSLog(@"FAILED TO OPEN DB");
    
    int result = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    if(result!=SQLITE_OK)
        NSLog(@"FAILED TO PREPARE STMT");
    
    BOOL colFound=NO;
    while(sqlite3_step(stmt)== SQLITE_ROW)
    {
        if(sqlite3_column_text(stmt, 1)!=nil){
            if([[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] isEqualToString:columnName]) {
                colFound=YES;
                break;
            }
        }
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
    return colFound;
}

-(void)addColumn:(NSString *)columnName dataType:(NSString *)type inTable:(TableName)table {
    
    NSMutableArray *tables = [NSMutableArray arrayWithObjects:@"Subject",@"Quiz",@"QuizAsset", nil];
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    const char *sql;

    NSString *sqltemp = [NSString stringWithFormat:@"alter table %@ add column %@ %@",[tables objectAtIndex:table],columnName,type];
    
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

-(NSInteger)getIdentiyFromTable:(TableName) table{

    NSMutableArray *tables = [NSMutableArray arrayWithObjects:@"Subject",@"Quiz",@"QuizAsset", nil];
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    const char *sql=[@"" UTF8String];
    NSString *sqltemp = [@"" stringByAppendingFormat:@"select seq from sqlite_sequence where name='%@'",[tables objectAtIndex:table]];
    sql = [sqltemp UTF8String];

    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"DB.sqlite"];
    if(sqlite3_open([cruddatabase UTF8String], &cruddb)!=SQLITE_OK)
        NSLog(@"FAILED TO OPEN DB");
    
    int result = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
    if(result!=SQLITE_OK)
        NSLog(@"FAILED TO PREPARE STMT");
    
    NSInteger res=0;
    while(sqlite3_step(stmt)== SQLITE_ROW)
    {
        res=sqlite3_column_int(stmt, 0);
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
    return res;
}

@end
