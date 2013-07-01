

#import <Foundation/Foundation.h>

@interface Help : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic, strong) NSString *purpose;
@property (nonatomic, strong) NSString *purpose2;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *exit;
@property (nonatomic, strong) NSString *nomenclature;
@property (nonatomic, strong) NSString *guidedAccess;
@property (nonatomic, strong) NSString *incomplete;
@property (nonatomic, strong) NSString *link;

- (id)initWithName:(NSString *)name purpose:(NSString *)purpose section:(NSString *)section action:(NSString *)action exit:(NSString *)exit nomenclature:(NSString *)nomenclature;

- (NSMutableArray *)getHelpTitle;
- (NSMutableArray *)getHelpTopic;

@end
