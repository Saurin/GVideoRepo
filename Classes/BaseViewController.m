
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
    info.sender = (UIViewController *)[self.navigationController.viewControllers lastObject];

    info.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:info animated:YES completion:nil];
}

-(void)setOtherRightBarButtons:(NSArray *)items {

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width=10;
    
    //UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    //[btn addTarget:self action:@selector(didInfoClick:) forControlEvents:UIControlEventTouchDown];
    //[info setCustomView:btn];

    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(didInfoClick:)];
        

//    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(0, 0, 24, 24)];
//    [btn setImage:[UIImage imageNamed:@"get_info.png"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(didInfoClick:) forControlEvents:UIControlEventTouchDown];
//    [info setCustomView:btn];
    
    NSMutableArray *allItems;
    if (items!=nil) {
        allItems = [NSMutableArray arrayWithArray:items];
        [allItems addObject:space];
        [allItems addObject:info];
    }
    else{
        allItems = [NSMutableArray arrayWithObjects:space,info,nil];
    }
    
    [self.navigationItem setRightBarButtonItems:allItems];
}

-(void)setNoRightBarButton {
    UIBarButtonItem *noButton = [[UIBarButtonItem alloc] init];
    [self.navigationItem setRightBarButtonItem:noButton];
}

@end
