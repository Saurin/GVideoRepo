

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
    return [NSMutableArray arrayWithObjects:@"Purpose",@"Action",@"Exit",@"Nomenclature",@"NomenclatureImage",@"Guided Access",@"Links for more Help", nil];
}

- (NSMutableArray *)getHelpTopic {
    return [NSMutableArray arrayWithObjects:self.purpose,self.action,self.exit,self.nomenclature,@"",self.guidedAccess,@"More information is at www.GuidedVideo.com", nil];
}

@end
