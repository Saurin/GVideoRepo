//
//  TopicViewDelegate.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/24/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#ifndef GuidedVideo_TopicViewDelegate_h
#define GuidedVideo_TopicViewDelegate_h


@protocol TopicViewDelegate <NSObject>

@optional
- (BOOL)isEditableButtonAtTag:(NSInteger)tag;

@end

#endif
