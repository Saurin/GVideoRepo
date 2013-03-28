
#import "BaseModelViewController.h"

@implementation BaseModelViewController

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

- (void)viewWillAppear:(BOOL)animated {
	
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen);
    CGFloat height = CGRectGetHeight(screen);
    
	CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(1.57079633);
	landscapeTransform = CGAffineTransformTranslate (landscapeTransform, +80.0, +100.0);
	
	[self.navigationController.view setTransform:landscapeTransform];
	self.navigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	self.navigationController.view.bounds  = CGRectMake(0.0, 0.0, width, height);
	self.navigationController.view.center  = CGPointMake (width/2, height/2);
	
	[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
    
    [self.navigationController.navigationBar setHidden:NO];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
