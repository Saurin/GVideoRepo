
#import "BaseViewController.h"
#import "InfoViewController.h"
#import "NSString+HexColor.h"
#import "MenuTableViewController.h"

@implementation BaseViewController {
    UIButton *btnInfo;
    UIBarButtonItem *download;
    UIPopoverController *downloadPopover;
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
    
    UIColor *color = [@"#32445E" getHexColor];
    [[UINavigationBar appearance] setTintColor:color];
}

-(void)viewDidLayoutSubviews {
    
    if(btnInfo!=nil){
        [btnInfo setFrame:CGRectMake(self.view.frame.size.width-30, 0, 30, 30)];
    }
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
    info.sender = [[((UIViewController *)[self.navigationController.viewControllers lastObject]) class] description];

    info.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:info animated:YES completion:nil];
}

-(IBAction)didDownloadClick:(id)sender {

    if(downloadPopover==nil){
        MenuTableViewController *menu = [[MenuTableViewController alloc] initWithNibName:@"MenuView" bundle:nil];
        downloadPopover = [[UIPopoverController alloc] initWithContentViewController:menu];
        //downloadPopover.delegate=self;
    }
    
    [downloadPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];

}

-(void)setOtherRightBarButtons:(NSArray *)items {
    
    if(btnInfo!=nil){
        [btnInfo removeFromSuperview];
    }
    btnInfo = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [btnInfo addTarget:self action:@selector(didInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnInfo setFrame:CGRectMake(self.view.frame.size.width-30, 0, 30, 30)];
    [self.view addSubview:btnInfo];

    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width=10;

    //special case, show only if something was downloaded
    download = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(didDownloadClick:)];
    [download setTintColor:[@"#32445E" getHexColor]];
    
    
    NSMutableArray *allItems;
    if (items!=nil) {
        allItems = [NSMutableArray arrayWithArray:items];
        [allItems addObject:space];
        //[allItems addObject:download];
    }
    else{
        allItems = [NSMutableArray arrayWithObjects:space,nil];
    }
    
    [self.navigationItem setRightBarButtonItems:allItems];
}

@end
