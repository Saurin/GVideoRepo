

#import "TutorialViewController.h"
#import "AppDelegate.h"
#import "Utility.h"

@implementation TutorialViewController {
    UIScrollView *tutorialScrollView;
    UIPageControl *pager;
    UIButton *btnTutorialClose;
    UIButton *btnDontShowAgain;
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
    
    [self addTutorialOverlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addTutorialOverlay{
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [backImage setImage:[UIImage imageNamed:@"overlay.png"]];
    [self.view addSubview:backImage];
    
    tutorialScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [tutorialScrollView setDelegate:self];
    [tutorialScrollView setContentSize:CGSizeMake(self.view.frame.size.height*3, self.view.frame.size.width)];
    [tutorialScrollView setBackgroundColor:[UIColor blackColor]];
    [tutorialScrollView setPagingEnabled:YES];
    [tutorialScrollView setScrollEnabled:YES];
    [tutorialScrollView setBounces:YES];
    [tutorialScrollView setAlpha:0.75];
    for (NSInteger i=0; i<3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.height*i, 0, self.view.frame.size.height, self.view.frame.size.width)];
        imgView.image=[UIImage imageNamed:[@"" stringByAppendingFormat:@"overlay_%d.png",i+1]];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [tutorialScrollView addSubview:imgView];
    }
    [self.view addSubview:tutorialScrollView];
    
    pager = [[UIPageControl alloc] init];
    pager.center = tutorialScrollView.center;
    pager.frame = CGRectMake(pager.frame.origin.x, self.view.frame.size.width-30, pager.frame.size.width, pager.frame.size.height);
    pager.numberOfPages=3;
    [self.view addSubview:pager];
    
    btnTutorialClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnTutorialClose addTarget:self action:@selector(didCloseTutorialClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnTutorialClose setAlpha:0.2];
    [btnTutorialClose setFrame:CGRectMake(150, 660, 100, 50)];
    [self.view addSubview:btnTutorialClose];
    
    btnDontShowAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDontShowAgain.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnDontShowAgain setFrame:CGRectMake(263, 675, 20, 20)];
    [btnDontShowAgain addTarget:self action:@selector(didDontShowAgainClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDontShowAgain];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page =  scrollView.contentOffset.x/1024;
    pager.currentPage=page;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [btnTutorialClose setHidden:YES];
    [btnDontShowAgain setHidden:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [btnTutorialClose setHidden:NO];
    [btnDontShowAgain setHidden:NO];
}

-(IBAction)didCloseTutorialClick:(id)sender {
    BOOL show = btnDontShowAgain.imageView.image==nil;
    [[[Utility alloc] init] setUserSettings:show keyName:[NSString stringWithFormat:@"Settings%d",400]];
    [((AppDelegate *)[UIApplication sharedApplication].delegate) CloseTutorial];
}

-(IBAction)didDontShowAgainClick:(id)sender{
    if(btnDontShowAgain.imageView.image==nil)
        [btnDontShowAgain setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    else{
        [btnDontShowAgain setImage:nil forState:UIControlStateNormal];
        btnDontShowAgain.imageView.image=nil;
    }
}

@end
