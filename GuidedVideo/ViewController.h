//
//  ViewController.h
//  GuidedVideo
//
//  Created by Mark Wade on 12/9/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "PasscodeViewController.h"

@interface ViewController : UIViewController <PasscodeViewControllerDelegate>

-(IBAction)didEditClick:(id)sender;
-(IBAction)didButtonClick:(id)sender;

@end
