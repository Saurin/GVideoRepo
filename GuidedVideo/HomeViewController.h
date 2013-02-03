//
//  HomeViewController.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 1/19/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 
#import "QuizViewController.h"
#import "CustomButton.h"
#import "Data.h"


@interface HomeViewController : UIViewController  <AddSubjectDelegate>

@property BOOL bLoginSuccess;

-(IBAction)didSaveAndCloseClick:(id)sender;

@end
