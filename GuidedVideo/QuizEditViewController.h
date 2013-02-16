//
//  QuizEditViewController.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "CustomButton.h"
#import "Subject.h"
#import "Data.h"

@interface QuizEditViewController : UIViewController<AddSubjectDelegate, UIActionSheetDelegate>

@property (nonatomic) Subject *subject;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonAction;
-(IBAction)didActionClick:(id)sender;

@end
