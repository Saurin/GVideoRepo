//
//  Menu.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 3/13/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "Menu.h"

@implementation Menu

- (id)initWithMenuId:(NSInteger)menuId name:(NSString *)menuName
{
    self = [super init];
    if (self) {
        
        self.menuId = menuId;
        self.menuName = menuName;
        
        return self;
    }
    return nil;
}

-(id)getMenuOptions {

    NSMutableArray *menuArray = [[NSMutableArray alloc] init];
    [menuArray addObject:[[Menu alloc] initWithMenuId:1 name:@"Subject"]];
    
    return  menuArray;
}

@end
