

#import "Help.h"

@implementation Help

- (id)initWithName:(NSString *)name purpose:(NSString *)purpose section:(NSString *)section action:(NSString *)action exit:(NSString *)exit nomenclature:(NSString *)nomenclature
{
    self = [super init];
    if (self) {
        
        self.name=name;
        self.purpose=purpose;
        self.section=section;
        self.action =action ;
        self.exit=exit;
        self.nomenclature=nomenclature;
        
        return self;
    }
    return nil;
}

- (NSMutableArray *)getHelpTitle {
    return [NSMutableArray arrayWithObjects:@"Purpose",@"Action",@"Exit",@"Incomplete",@"Nomenclature",@"NomenclatureImage",@"Guided Access",@"More Help", nil];
}

- (NSMutableArray *)getHelpTopic {
    return [NSMutableArray arrayWithObjects:self.purpose,self.action,self.exit,self.incomplete,self.nomenclature,@"",self.guidedAccess,@"Go to www.GuidedVideo.com", nil];
}

@end
