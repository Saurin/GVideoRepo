

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "Help.h"

@implementation DetailViewController {
    Help *help;
}

#pragma mark -
#pragma mark View lifecycle

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
    
    NSMutableArray *helpArray = ((AppDelegate *)[UIApplication sharedApplication].delegate).helpArray;
    help=(Help *)[[helpArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name=%@",self.sender]] objectAtIndex:0];
}

-(void)viewDidLayoutSubviews {

    for (UIView *vw in self.view.subviews) {
        [vw removeFromSuperview];
    }
    
    if([self.sender isEqualToString:@"About"]){
        [self configureAbout];
    }
    else if([self.sender isEqualToString:@"Review"]){
        [self configureReview];
    }
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

-(void)configureAbout {

    //add label
    CGRect frame = CGRectMake(30, 30, self.view.frame.size.width-60, 30);
    UILabel *lbl = [self addLabelAt:frame withText:help.purpose];

    //add button to take to review screen
    frame.origin.y+=lbl.frame.size.height+lbl.frame.origin.y+20;
    UIButton *btn=[self addActionButtonAt:frame];
    
    //add additional label here
    frame.origin.y=btn.frame.size.height+btn.frame.origin.y+30;
    [self addLabelAt:frame withText:help.purpose2];
}

-(void)configureReview {

    //add label
    CGRect frame = CGRectMake(30, 30, self.view.frame.size.width-60, 30);
    UILabel *lbl = [self addLabelAt:frame withText:help.purpose];
    
    //add button to take to review screen
    frame.origin.y+=lbl.frame.size.height+lbl.frame.origin.y+20;
    [self addActionButtonAt:frame];
}

#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(IBAction)reviewClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/mugshots-parking-lots-free/id526819560?mt=8"]];
}

- (CGFloat)heightForLabel:(UILabel *)label
{
    UIFont *cellFont = [UIFont systemFontOfSize:15];
    NSLog(@"%f",self.view.frame.size.width);
    CGSize constraintSize = CGSizeMake(self.view.frame.size.width-60, MAXFLOAT);
    
    NSString *cellText = label.text;
    CGSize labelDetailSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelDetailSize.height;
}

-(UILabel *)addLabelAt:(CGRect)frame withText:(NSString *)text {
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:text];
    lbl.numberOfLines=0;
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setLineBreakMode:UILineBreakModeWordWrap];
    [lbl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    frame.size.height = [self heightForLabel:lbl];
    lbl.frame=frame;
    [self.view addSubview:lbl];
    
    return lbl;
}

-(UIButton *)addActionButtonAt:(CGRect)frame {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(reviewClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [btn setTitle:help.action forState:UIControlStateNormal];
    [btn setFrame:frame];
    [self.view addSubview:btn];
    
    return btn;
}

-(void)loadPage {
//    WebViewController *newDetailViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
//    [newDetailViewController setLoadFor:@"http://www.guidedvieo.com"];
//    detailViewController = newDetailViewController;
//    
}
@end
