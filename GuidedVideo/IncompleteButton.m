//
//  IncompleteButton.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/9/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "IncompleteButton.h"

@implementation IncompleteButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.alpha=0.1;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext(); //get the graphics context
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    for(int j=0;j<50;j++){
        CGContextMoveToPoint(ctx, 0, 70-j);
        CGContextAddLineToPoint( ctx, 70-j,0);
        CGContextStrokePath(ctx);
    }
    
}

@end
