//
//  SubjectViewController.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 3/15/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "SubjectViewController.h"

@interface SubjectViewController ()

@end

@implementation SubjectViewController

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
    
    UIViewController *vc=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    UIViewController *detailViewController = [self.splitViewController.viewControllers objectAtIndex:1];
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:vc, detailViewController, nil];
    self.splitViewController.viewControllers = viewControllers;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
