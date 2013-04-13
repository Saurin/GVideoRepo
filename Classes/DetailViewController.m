

#import "DetailViewController.h"

@implementation DetailViewController

#pragma mark -
#pragma mark View lifecycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
}


- (void)viewDidUnload {
	[super viewDidUnload];
}

#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



@end
