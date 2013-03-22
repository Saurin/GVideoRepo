//
//  Utility.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 3/14/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

typedef void (^UtilityImageHandler)(NSString *url, UIImage *image);
@property (nonatomic, copy) UtilityImageHandler utilityImageHandler;

-(void)setImageFromAssetURL:(NSString*)url completion:(UtilityImageHandler)completionBlock;

@end
