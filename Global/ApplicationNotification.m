

#import "ApplicationNotification.h"

@implementation ApplicationNotification

+ (ApplicationNotification *)notification {
    
    static ApplicationNotification  *_notification = nil;
    
    @synchronized(self)
    {
        if (!_notification) {
            _notification = [[ApplicationNotification alloc] init];
        }
        
        return _notification;
    }
}

//sends notification to SubjectListViewController in MasterViewController to highlight subject
-(void)postNotificationFromSubjectView:(id)object userInfo:(NSDictionary *)userInfo {

    if(userInfo==nil){

        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SubjectListViewController" object:object]];
    }
}

//sends notification to InstructionListViewController in MasterViewController to highlight quiz
-(void)postNotificationFromInstructionView:(id)object userInfo:(NSDictionary *)userInfo {
    
    if(userInfo==nil){
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"InstructionListViewController" object:object]];
    }
}

//sends notification to AlternativeListViewController in MasterViewController to highlight quizoption
-(void)postNotificationFromAlternativeView:(id)object userInfo:(NSDictionary *)userInfo {
    
    if(userInfo==nil){
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AlternativeListViewController" object:object]];
    }
}

@end
