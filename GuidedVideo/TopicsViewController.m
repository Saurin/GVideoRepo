

#import "TopicsViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "OHAlertView.h"
#define ButtonCount 16

@implementation TopicsViewController {
    float ratio;
    UIView *portraitView;
}

-(void)viewDidLoad {
    
    ratio = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
    
    //Just to notify user that in play mode they will have no way to come back
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Need some message to let user know that there is no way to exit this view" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alert show];
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

-(void)viewWillAppear:(BOOL)animated {
    
    [self setTitle:@""];
    
    [(TopicView *)self.view redraw];
    [self createButtons];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake)
	{
        [self resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
	}
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
