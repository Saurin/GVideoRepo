

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Subject.h"
#import "QuizPage.h"
#import "QuizOption.h"

typedef NS_ENUM(NSInteger, TableName) {
    DBTableSubject = 0,
    DBTableQuiz=1,
    DBTableQuizOption=2,
    DBTableParameter
};

@interface CrudOp : NSObject <UIAlertViewDelegate> {
    
    sqlite3 *db;
    NSFileManager *fileMgr;
    NSString *homeDir;
}

+ (CrudOp *)sharedDB;

-(NSMutableArray*)GetRecords:(TableName)table where:(NSString*)filter;
-(void)InsertRecordInTable:(TableName)table withObject:(id)obj;
-(void)DeleteRecordFromTable:(TableName)table withId:(NSInteger)index;
-(void)DeleteRecordFromTable:(TableName)table where:(NSString *)where;
-(void)UpdateRecordForTable:(TableName)table withObject:(id)obj;
-(void)UpdateTable:(TableName)table set:(NSString *)set where:(NSString *)where;
-(BOOL)isColumnExist:(NSString *)columnName inTable:(TableName)table;
-(void)addColumn:(NSString *)columnName dataType:(NSString *)type inTable:(TableName)table;
-(NSInteger)getIdentiyFromTable:(TableName) table;
@end
