//
//  QuizEditViewController.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "BaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CustomButton.h"
#import "Subject.h"
#import "Data.h"
#import "QuizView.h"

@interface QuizEditViewController : BaseViewController<SubstitutableDetailViewController,AddSubjectDelegate, UIActionSheetDelegate>

@property (nonatomic) Subject *subject;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonAction;
-(IBAction)didActionClick:(id)sender;

@end
