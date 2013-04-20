

#import <Foundation/Foundation.h>

@interface Help : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic, strong) NSString *purpose;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *exit;


- (id)initWithName:(NSString *)name purpose:(NSString *)purpose section:(NSString *)section action:(NSString *)action exit:(NSString *)exit;
- (NSMutableArray *)getHelpTitle;
- (NSMutableArray *)getHelpTopic;
@end
