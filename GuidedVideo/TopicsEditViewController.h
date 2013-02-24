//
//  TopicsEditViewController.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TopicView.h"
#import "QuizViewController.h"
#import "CustomButton.h"
#import "Data.h"

@interface TopicsEditViewController : UIViewController <AddSubjectDelegate>

-(IBAction)didSaveAndCloseClick:(id)sender;

@end
