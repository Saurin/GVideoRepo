
#import "BaseModelViewController.h"

@implementation BaseModelViewController {
    UILabel *lblBrand;
}

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

-(void)addBrandText {
    
    [lblBrand removeFromSuperview];
    CGFloat viewHeight=self.view.frame.size.height;
    CGFloat viewWidth=self.view.frame.size.width;

    lblBrand = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight-15, viewWidth, 10)];
    NSLog(@"%f %f %f %f",lblBrand.frame.origin.x,lblBrand.frame.origin.y,lblBrand.frame.size.height,lblBrand.frame.size.width);
    [lblBrand setBackgroundColor:[UIColor clearColor]];
    [lblBrand setFont:[UIFont boldSystemFontOfSize:10]];
    [lblBrand setTextAlignment:NSTextAlignmentCenter];
    [lblBrand setText:@"GuidedVideo.com - Shake device to go back"];
    [self.view addSubview:lblBrand];
}

- (void)viewWillAppear:(BOOL)animated {
	
    if(self.lockOrientation) {
        
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
    }
    [self.navigationController.navigationBar setHidden:NO];
}

-(BOOL)shouldAutorotate {
    return !self.lockOrientation;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return  !self.lockOrientation;
    
}

- (NSUInteger)supportedInterfaceOrientations {
    return self.lockOrientation? UIInterfaceOrientationMaskLandscape: UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
