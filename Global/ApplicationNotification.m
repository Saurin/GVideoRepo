//
//  ApplicationNotification.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 3/22/13.
//
//

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

//sends notification to SubjectViewController in MasterViewController to highlight subject
-(void)postNotificationFromSubjectView:(id)object userInfo:(NSDictionary *)userInfo {

    if(userInfo==nil){

        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SubjectListViewController" object:object]];
    }
}


@end
