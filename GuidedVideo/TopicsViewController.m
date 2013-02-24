

#import "TopicsViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#define ButtonCount 16

@implementation TopicsViewController {
    float ratio;
    UIView *portraitView;
}

-(void)viewDidLoad {
    
    ratio = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
}

-(void)viewWillLayoutSubviews {

    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        
        float newHeight=self.view.frame.size.height*ratio;
        float newTop = (self.view.frame.size.height-newHeight)/2;
        self.view.frame = CGRectMake(0, newTop, self.view.frame.size.width, newHeight);
    }
    
    [self setTitle:@""];
    
    [(TopicView *)self.view redraw];
    [self createButtons];
}


//-(BOOL)shouldAutorotate {
//
//    [portraitView removeFromSuperview];
//    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
//
//        portraitView = [[UIView alloc] initWithFrame:self.view.bounds];
//        UILabel *lbl = [[UILabel alloc] initWithFrame:self.view.bounds];
//        [lbl setTextAlignment:NSTextAlignmentCenter];
//        lbl.text = @"Not supported in Portrait mode";
//        [portraitView addSubview:lbl];
//        [self.view addSubview:portraitView];
//    }
//
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setTitle:@""];
    
    [(TopicView *)self.view redraw];
    [self createButtons];
}


-(void)createButtons {
    
    //get existing subjects, if any
    NSMutableArray *buttons = [[Data sharedData] getSubjects];
        
    //set up subject buttons
    for(NSInteger i=0;i<buttons.count;i++){
        
        Subject *sub = [buttons objectAtIndex:i];
        
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        [btn createSubjectButtonAtIndex:i+1 withSubject:sub];
        
        if(![sub.subjectName isEqualToString:@""]){
            [btn addText:sub.subjectName];
        }
        if(![sub.assetUrl isEqualToString:@""]){
            [btn addImageUsingAssetURL:sub.assetUrl];
        }
        
        [btn setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"Play"]) {
        
        self.title = ((Subject *)sender).subjectName;
        
        QuizViewController *vc = [segue destinationViewController];
        vc.subject = (Subject *)sender;
    }

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(IBAction)didEditClick:(id)sender {
    [self setTitle:@"Done"];
    [self performSegueWithIdentifier:@"Edit" sender:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    for(NSInteger i=0;i<ButtonCount;i++){
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        if ([touch view] == btn && btn.bEmptyButton) {
            [btn setAlpha:.6];
            break;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];

    for(NSInteger i=0;i<ButtonCount;i++){
        
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        if ([touch view] == btn ) {
            
            [self performSegueWithIdentifier:@"Play" sender:[btn getSubject]];
            return;
        }
    }
}

@end
