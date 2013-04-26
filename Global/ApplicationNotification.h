

#import <Foundation/Foundation.h>


@interface ApplicationNotification : NSObject

typedef NS_ENUM(NSInteger, ANReceiver) {
    SubjectListMaster,
    SubjectListDetail
};

+(ApplicationNotification *)notification;
-(void)postNotificationFromSubjectView:(id)object userInfo:(NSDictionary *)userInfo;
-(void)postNotificationFromInstructionView:(id)object userInfo:(NSDictionary *)userInfo;
-(void)postNotificationFromAlternativeView:(id)object userInfo:(NSDictionary *)userInfo;
-(void)postNotificationChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation;
-(void)postNotificationToLoadDefaults;
@end
