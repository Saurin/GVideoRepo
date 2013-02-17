//
//  TopicView.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/12/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopicViewDelegate <NSObject>

@optional
- (BOOL)isEditableButtonAtTag:(NSInteger)tag;

@end


@interface TopicView : UIView <TopicViewDelegate>

@property (nonatomic, readwrite, assign) IBOutlet id delegate;

-(void)redraw;

@end


