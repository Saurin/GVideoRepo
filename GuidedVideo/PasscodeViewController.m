//
//  PasscodeViewController.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 1/23/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "PasscodeViewController.h"

@implementation PasscodeViewController

-(void)viewDidLoad {
    
    id p = [self initForAction:PasscodeActionEnter];
    super.delegate=self;
    self.passcode=@"0000";
    self.simple=YES;
    self.modalInPopover=YES;
    p=nil;
    

    
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - PAPasscodeViewControllerDelegate

- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller {
    

    [self dismissViewControllerAnimated:YES completion:^() {
        [self.presenter didLogin];
    }];
}

@end
