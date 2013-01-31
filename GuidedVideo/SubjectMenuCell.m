//
//  SubjectMenuCell.m
//  GuidedVideo
//
//  Created by Mark Wade on 12/16/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import "SubjectMenuCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SubjectMenuCell

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        [bgView.layer insertSublayer:gradient atIndex:0];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 4;
        self.selectedBackgroundView = bgView;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
