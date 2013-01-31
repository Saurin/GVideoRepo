//
//  PasscodeViewController.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 1/23/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAPasscodeViewController.h"

@protocol PasscodeViewControllerDelegate <NSObject>

-(void)didLogin;

@end

@interface PasscodeViewController : PAPasscodeViewController <PAPasscodeViewControllerDelegate>

@property (nonatomic,strong) id presenter;

@end
