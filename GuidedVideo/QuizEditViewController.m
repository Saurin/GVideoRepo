//
//  QuizEditViewController.m
//  GuidedVideo
//
//  Created by Mark Wade on 1/13/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "QuizEditViewController.h"

@interface QuizEditViewController ()

@end

@implementation QuizEditViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickBack:(id)sender {
    
    NSLog(@"didClicBack");
    if ([self.delegate respondsToSelector:@selector(didCompleteAddQuiz)]) {
        [self.delegate didCompleteAddQuiz];
        
    }

}
@end
