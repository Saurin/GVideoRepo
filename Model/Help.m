

#import "Help.h"

@implementation Help

- (id)initWithName:(NSString *)name purpose:(NSString *)purpose section:(NSString *)section action:(NSString *)action exit:(NSString *)exit
{
    self = [super init];
    if (self) {
        
        self.name=name;
        self.purpose=purpose;
        self.section=section;
        self.action =action ;
        self.exit=exit;
        
        return self;
    }
    return nil;
}

- (NSMutableArray *)getHelpTitle {
    return [NSMutableArray arrayWithObjects:@"Section",@"Purpose",@"Action",@"Exit", nil];
}

- (NSMutableArray *)getHelpTopic {
    return [NSMutableArray arrayWithObjects:self.section,self.purpose,self.action,self.exit, nil];
}

@end
