//
//  Application.h
//  GuidedVideo
//
//  Created by Mark Wade on 12/16/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Application : NSObject {

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+ (Application*)sharedManager;

+ (void)addApplicationObservers;

@end
