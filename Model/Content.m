//
//  Content.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 6/3/13.
//
//

#import "Content.h"

@implementation Content

- (id)initWithName:(NSString *)name url:(NSString *)url thumb:(NSString *)thumb{
    self = [super init];
    if (self) {
        
        self.name = name;
        self.url = url;
        self.thumbnail=thumb;
        
        return self;
    }
    return nil;

}


@end
