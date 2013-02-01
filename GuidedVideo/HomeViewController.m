//
//  HomeViewController.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 1/19/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "HomeViewController.h"
#define ButtonCount 16
#define VPadding 20
#define HPadding 40

@implementation HomeViewController

-(void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self loadButtons];
    [self createButtons];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)loadButtons {
       
    NSInteger tag=1;
    double buttonHeight = (self.view.frame.size.height-VPadding*6)/5;
    double buttonWidth = (self.view.frame.size.width-HPadding*6)/5;
    
    for (NSInteger i=1;i<ButtonCount;i++) {
        [[self.view viewWithTag:i] removeFromSuperview];
    }
    
    //bottom row
    for(NSInteger i=0;i<5;i++){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, self.view.frame.size.height-buttonHeight-VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    //right column
    for(NSInteger i=3;i>0;i--){
        
        CGRect frame = CGRectMake(self.view.frame.size.width-buttonWidth-HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    
    //top row
    for(NSInteger i=4;i>=0;i--){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    //left column
    for(NSInteger i=1;i<=3;i++){
        
        CGRect frame = CGRectMake(HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    NSInteger height = self.view.frame.size.height-buttonHeight*2-VPadding*4;
    NSInteger width = self.view.frame.size.width-buttonWidth*2-HPadding*4;
    
    CGRect frame = CGRectMake((self.view.frame.size.width-width)/2, (self.view.frame.size.height-height)/2, width, height);
    CustomButton *videoButton = [[CustomButton alloc] initWithFrame:frame];
    videoButton.tag=101;
    [self.view addSubview:videoButton];
    [videoButton setHidden:YES];
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
    for(NSInteger i=0;i<ButtonCount;i++){
    
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        [btn createButtonAtIndex:i+1];
        [btn setEditable:YES];

        btn.delegate=self;
        btn.presentingController=self;
        btn.buttonType=CustomButtonTypeSubject;
        
        if(buttons.count>i){
            
            Subject *sub = [buttons objectAtIndex:i];
            if([sub.subjectName isEqualToString:@""]){
                [btn addImageUsingAssetURL:sub.assetUrl];
            }
            else{
                [btn addText:sub.subjectName];
            }
            btn.bEmptyButton=NO;
            [btn setHidden:NO];
        }
        else{
            btn.bEmptyButton=YES;
            [btn setHidden:YES];
        }
    }

    CustomButton *btn = (CustomButton *)[self.view viewWithTag:buttons.count+1];
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
        if ([touch view] == btn && btn.bEmptyButton) {
            
            [btn setAlpha:1];
            btn.bEmptyButton=NO;
            [btn addText:@""];

            
            CustomButton *btn1 = (CustomButton *)[self.view viewWithTag:i+2];
            [btn1 setHidden:NO];
            if(i+2!=ButtonCount)
                [btn1 addNewButton];
            
            break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Login"]) {
        
        QuizViewController *vc = [segue destinationViewController];
        vc.subjectAtIndex = [((CustomButton *)sender) getIndex];
    }
}

-(IBAction)didSaveAndCloseClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveButton:(CustomButton *)btn withText:(NSString *)text asset:(NSString *)assetUrl {
    
    Subject *sub = [[Subject alloc] init];
    sub.subjectName=text;
    sub.assetUrl=assetUrl;
    [[Data sharedData] saveSubjectAtIndex:[btn getIndex] subject:sub];
}

-(void)removeButton:(CustomButton *)btn {
    
    NSMutableArray *buttons = [[Data sharedData] getSubjects];
    if(buttons.count>[btn getIndex])
    {
        Subject *sub=[buttons objectAtIndex:[btn getIndex]];
    
        [[Data sharedData] deleteSubjectAtIndex:sub.subjectId];
    }
    [self loadButtons];
    [self createButtons];
}

- (void)createQuiz:(CustomButton *)btn {
    [self performSegueWithIdentifier:@"Quiz" sender:btn];
}


@end
