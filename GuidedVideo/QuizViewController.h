//
//  QuizViewController.h
//  GuidedVideo
//
//  Created by Mark Wade on 1/13/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>  
#import "CustomButton.h"
#import "Subject.h"
#import "Data.h"

@interface QuizViewController : UIViewController<AddSubjectDelegate>

@property (nonatomic) Subject *subject;

@end
