//
//  TopicView.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/12/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicViewDelegate.h"



@interface TopicView : UIView <TopicViewDelegate>

@property (nonatomic, readwrite, assign) IBOutlet id delegate;

-(void)redraw;

@end


