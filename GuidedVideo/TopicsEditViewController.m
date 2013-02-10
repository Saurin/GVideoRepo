//
//  TopicsEditViewController.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "TopicsEditViewController.h"
#define ButtonCount 16
#define VPadding 20
#define HPadding 40

@implementation TopicsEditViewController

-(void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.title =@"Topics";
    self.navigationItem.rightBarButtonItems = nil;
    
    
    [self loadButtons];
    [self createButtons];
    
}

-(BOOL)shouldAutorotate {
    return NO;
}

-(void)loadButtons {
    
    NSInteger tag=1;
    double buttonHeight = (self.view.frame.size.height-VPadding*6)/5;
    double buttonWidth = (self.view.frame.size.width-HPadding*6)/5;
    
    for (NSInteger i=1;i<ButtonCount;i++) {
        [[self.view viewWithTag:i] removeFromSuperview];
    }
    [[self.view viewWithTag:101] removeFromSuperview];
    
    //bottom row
    for(NSInteger i=0;i<5;i++){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, self.view.frame.size.height-buttonHeight-VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
        [btn setEditable:YES];
        btn.delegate=self;
        btn.presentingController=self;
    }
    
    //right column
    for(NSInteger i=3;i>0;i--){
        
        CGRect frame = CGRectMake(self.view.frame.size.width-buttonWidth-HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
        [btn setEditable:YES];
        btn.delegate=self;
        btn.presentingController=self;
    }
    
    
    //top row
    for(NSInteger i=4;i>=0;i--){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
        [btn setEditable:YES];
        btn.delegate=self;
        btn.presentingController=self;
    }
    
    //left column
    for(NSInteger i=1;i<=3;i++){
        
        CGRect frame = CGRectMake(HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
        [btn setEditable:YES];
        btn.delegate=self;
        btn.presentingController=self;
    }
    
//Joe doesn't like playing instructional video here
//    NSInteger height = self.view.frame.size.height-buttonHeight*2-VPadding*4;
//    NSInteger width = self.view.frame.size.width-buttonWidth*2-HPadding*4;
    
//    CGRect frame = CGRectMake((self.view.frame.size.width-width)/2, (self.view.frame.size.height-height)/2, width, height);
//    CustomButton *videoButton = [[CustomButton alloc] initWithFrame:frame];
//    videoButton.tag=101;
//    [self.view addSubview:videoButton];
}

-(void)createButtons {
    
    //get existing subjects, if any
    NSMutableArray *buttons = [[Data sharedData] getSubjects];
    
    //set up video button
    CustomButton *videoButton = (CustomButton *)[self.view viewWithTag:101];
    [videoButton createButtonAtIndex:101];
    [videoButton setEditable:YES];
    
    videoButton.delegate=self;
    videoButton.presentingController=self;
    videoButton.buttonType=CustomButtonTypeVideo;
    
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

-(IBAction)didSaveAndCloseClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveSubjectButton:(CustomButton *)btn withSubject:(Subject *)subject {
    
    NSLog(@"%d %@ %@",subject.subjectId,subject.subjectName,subject.assetUrl);
    [[Data sharedData] saveSubject:subject];
    
    [self loadButtons];
    [self createButtons];
    
}

-(void)removeSubjectButton:(CustomButton *)btn withSubject:(Subject *)subject {
    
    NSLog(@"%d %@ %@",subject.subjectId,subject.subjectName,subject.assetUrl);
    if(subject!=nil && subject.subjectId!=0)
    {
        [[Data sharedData] deleteSubjectWithSubjectId:subject.subjectId];
    }
    
    [self loadButtons];
    [self createButtons];
}

-(void)createQuizAtButton:(CustomButton *)btn forSubject:(Subject *)subject {
    
    [self performSegueWithIdentifier:@"Quiz" sender:subject];
}



@end
