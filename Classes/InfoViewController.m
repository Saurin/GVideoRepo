

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[[UIAlertView alloc] initWithTitle:[[self.sender class] description] message:@"Info view goes here.." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];

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
