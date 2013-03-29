//
//  ApplicationNotification.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 3/22/13.
//
//

#import <Foundation/Foundation.h>


@interface ApplicationNotification : NSObject

typedef NS_ENUM(NSInteger, ANReceiver) {
    SubjectListMaster,
    SubjectListDetail
};

+(ApplicationNotification *)notification;
-(void)postNotificationFromSubjectView:(id)object userInfo:(NSDictionary *)userInfo;
-(void)postNotificationFromInstructionView:(id)object userInfo:(NSDictionary *)userInfo;
@end
