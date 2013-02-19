

#import "TopicsViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#define ButtonCount 16
#define VPadding 20
#define HPadding 40

@implementation TopicsViewController

-(void)viewWillAppear:(BOOL)animated {}
-(void)viewDidLayoutSubviews {
    
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
