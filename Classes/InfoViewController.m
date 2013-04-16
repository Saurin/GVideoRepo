

#import "InfoViewController.h"

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[[OHAlertView alloc] initWithTitle:[[self.sender class] description] message:@"Info view goes here..." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] showWithTimeout:2 timeoutButtonIndex:0];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.view addSubview:toolbar];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didDoneClick:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items=[NSArray arrayWithObjects:space,done, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didDoneClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
