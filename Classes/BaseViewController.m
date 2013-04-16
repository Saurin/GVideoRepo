
#import "BaseViewController.h"
#import "InfoViewController.h"

@implementation BaseViewController

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

-(void)makeRoundRectView:(UIView *)view layerRadius:(NSInteger)radius {
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

-(IBAction)didInfoClick:(id)sender {
    
    
    InfoViewController *info = [[InfoViewController alloc] initWithNibName:@"InfoView" bundle:nil];
    info.sender = sender;

    info.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:info animated:YES completion:nil];
}

@end
