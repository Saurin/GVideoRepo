//
//  Content.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 6/3/13.
//
//

#import <Foundation/Foundation.h>

@interface Content : NSObject

@property (nonatomic) NSString *url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thumbnail;


- (id)initWithName:(NSString *)name url:(NSString *)url thumb:(NSString *)thumb;


@end
