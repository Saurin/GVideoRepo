
#import "TopicsEditViewController.h"
#define ButtonCount 16

@implementation TopicsEditViewController

{
    float ratio;
    UIView *portraitView;
}

-(void)viewDidLoad {
    
    ratio = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
}

-(void)viewWillLayoutSubviews {
    
//    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
//        
//        float newHeight=self.view.frame.size.height*ratio;
//        float newTop = (self.view.frame.size.height-newHeight)/2;
//        self.view.frame = CGRectMake(0, newTop, self.view.frame.size.width, newHeight);
//    }
//    
//    [self setTitle:@"Topics"];
//    self.navigationItem.rightBarButtonItems = nil;
//    
//    [(TopicView *)self.view redraw];
//    [self createButtons];
}


-(void)viewWillAppear:(BOOL)animated {
    
    self.title =@"Topics";
    self.navigationItem.rightBarButtonItems = nil;
    
    
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
        
        if(![[Data sharedData] isSubjectProgrammed:sub.subjectId])
            [btn showIncomplete];

        [btn setHidden:NO];
    }
    
    CustomButton *btn = (CustomButton *)[self.view viewWithTag:buttons.count+1];
    [btn createSubjectButtonAtIndex:buttons.count+1 withSubject:nil];
    [btn addNewButton];
    [btn setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    for(NSInteger i=0;i<ButtonCount;i++){
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        if ([touch view] == btn) {
            
            [btn setAlpha:.6];
            break;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    for(NSInteger i=0;i<ButtonCount;i++){
        
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        if ([touch view] == btn) {
            
            [btn setAlpha:1];
            //[btn performAction];

            break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Quiz"]) {
        
        self.title = ((Subject *)sender).subjectName;
        
        QuizViewController *vc = [segue destinationViewController];
        vc.subject = (Subject *)sender;
    }
}

-(BOOL)isEditableButtonAtTag:(NSInteger)tag {
    return YES;
}

-(IBAction)didSaveAndCloseClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveSubjectButton:(CustomButton *)btn withSubject:(Subject *)subject {
    
    NSLog(@"%d %@ %@",subject.subjectId,subject.subjectName,subject.assetUrl);
    [[Data sharedData] saveSubject:subject];
    
    [(TopicView *)self.view redraw];
    [self createButtons];
    
}

-(void)removeSubjectButton:(CustomButton *)btn withSubject:(Subject *)subject {
    
    NSLog(@"%d %@ %@",subject.subjectId,subject.subjectName,subject.assetUrl);
    if(subject!=nil && subject.subjectId!=0)
    {
        [[Data sharedData] deleteSubjectWithSubjectId:subject.subjectId];
    }
    
    [(TopicView *)self.view redraw];
    [self createButtons];
}

-(void)createQuizAtButton:(CustomButton *)btn forSubject:(Subject *)subject {
    
    [self performSegueWithIdentifier:@"Quiz" sender:subject];
}



@end
