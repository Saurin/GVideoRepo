//
//  Application.m
//  GuidedVideo
//
//  Created by Mark Wade on 12/16/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import "Application.h"

@implementation Application

@synthesize managedObjectContext;

static Application *sharedApplicationManager = nil;

+ (Application*)sharedManager
{
    if (sharedApplicationManager == nil) {
        sharedApplicationManager = [[super allocWithZone:NULL] init];
        
        [self addApplicationObservers];
    }
    
    return sharedApplicationManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:kReachabilityChangedNotification];
//    [[NSNotificationCenter defaultCenter] removeObserver:kNotification_SynchNeeded];
}

+ (void)addApplicationObservers {
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
}


@end
