//
//  Menu.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 3/13/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property (nonatomic) NSInteger menuId;
@property (nonatomic, retain) NSString *menuName;

- (id)initWithMenuId:(NSInteger)menuId name:(NSString *)menuName;

@end
