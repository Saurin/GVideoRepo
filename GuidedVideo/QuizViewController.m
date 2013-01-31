//
//  QuizViewController.m
//  GuidedVideo
//
//  Created by Mark Wade on 1/13/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "QuizViewController.h"
#import "Quiz.h"
#define ButtonCount 12
#define VPadding 20
#define HPadding 40

@implementation QuizViewController {
    NSInteger quizIndex;
}

@synthesize subjectAtIndex;

-(void)viewDidLoad {

    quizIndex=0;
    [self loadButtons];
    [self addNavigationButtons];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self createButtons];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)loadButtons {
    
    for (UIView* v in self.view.subviews) {
        [v removeFromSuperview];
    }
    
    [self.navigationController setNavigationBarHidden:NO];
    NSInteger barHeight = self.navigationController.navigationBar.frame.size.height;
    
    NSInteger tag=1;
    NSInteger buttonCount = ButtonCount/4+1;
    double buttonHeight = (self.view.frame.size.height-barHeight-VPadding*(buttonCount+1))/buttonCount;
    double buttonWidth = (self.view.frame.size.width-HPadding*(buttonCount+1))/buttonCount;
    
    //bottom row
    for(NSInteger i=0;i<4;i++){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, self.view.frame.size.height-buttonHeight-barHeight-VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    //right column
    for(NSInteger i=2;i>0;i--){
        
        CGRect frame = CGRectMake(self.view.frame.size.width-buttonWidth-HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    
    //top row
    for(NSInteger i=3;i>=0;i--){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    //left column
    for(NSInteger i=1;i<=2;i++){
        
        CGRect frame = CGRectMake(HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
}

-(void)createButtons {
    
    Subject *sub = [[Data sharedData] getSubjectAtIndex:subjectAtIndex];
    
    Quiz *quiz;
    if(sub.quizzes!=nil && sub.quizzes.count>quizIndex)                     //get current quiz
    {
        quiz = [sub.quizzes objectAtIndex:quizIndex];
    }
        
    for(NSInteger i=0;i<ButtonCount;i++){
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        [btn createButtonAtIndex:i];
        [btn setEditable:YES];
        
        btn.delegate=self;
        btn.presentingController=self;
        btn.buttonType = CustomButtonTypeQuiz;
        
        if(quiz!=nil && quiz.assetUrls.count>i){
            if(![[quiz.assetUrls objectAtIndex:i] isEqualToString:@""]){

                btn.bEmptyButton=NO;
                [btn setHidden:NO];
                NSLog(@"%@",[quiz.assetUrls objectAtIndex:i]);
            }
            else{
                btn.bEmptyButton=YES;
                [btn setHidden:NO];
                [btn addNewButton];
            }
        }
    }
    
    if(quiz==nil){
        [(CustomButton *)[self.view viewWithTag:1] addNewButton];
        [[self.view viewWithTag:1] setHidden:NO];
    }
    else{
        [(CustomButton *)[self.view viewWithTag:quiz.assetUrls.count+1] addNewButton];
        [[self.view viewWithTag:quiz.assetUrls.count+1] setHidden:NO];
    }
}

-(void)addNavigationButtons {

    if(quizIndex==0){
        UIBarButtonItem *Button2 = [[UIBarButtonItem alloc] initWithTitle:@"Next Quiz" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(addNewQuiz:)] ;
        
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:Button2, nil];
        
    }
    else{
        UIBarButtonItem *Button1 = [[UIBarButtonItem alloc]initWithTitle:@"Previous Quiz" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(Button1Clicked:)] ;
        
        UIBarButtonItem *Button2 = [[UIBarButtonItem alloc] initWithTitle:@"Next Quiz" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(addNewQuiz:)] ;
        
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:Button2, Button1, nil];
    }
    
    self.title = [NSString stringWithFormat:@"Quiz %d",quizIndex];
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

-(IBAction)addNewQuiz:(id)sender {
    
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        quizIndex++;
                        [self loadButtons];
                        [self createButtons];
                        [self addNavigationButtons];
                    }
                    completion:NULL];
}

-(void)customButton:(CustomButton *)btn saveSubject:(Subject *)subject {
//    NSInteger index = [btn getIndex];
//    [[Data sharedData] saveSubjectAtIndex:subjectAtIndex subject:subject];
}

-(void)saveButton:(CustomButton *)btn withText:(NSString *)text asset:(NSString *)assetUrl {
    
    Subject *sub=[[Data sharedData] getSubjectAtIndex:subjectAtIndex];
    
    if(sub.quizzes==nil)
        sub.quizzes = [[NSMutableArray alloc] init];
    
    Quiz *quiz;
    if(sub.quizzes.count>quizIndex){
        quiz = [sub.quizzes objectAtIndex:quizIndex];
    }
    else{
        quiz=[[Quiz alloc] init];
    }
    
    if(quiz.assetUrls==nil)
        quiz.assetUrls = [[NSMutableArray alloc] init];
    
    if(quiz.assetUrls.count>[btn getIndex]){
        NSString *old =[quiz.assetUrls objectAtIndex:[btn getIndex]];
        NSLog(@"%@",old);
        
        [quiz.assetUrls replaceObjectAtIndex:[btn getIndex] withObject:assetUrl];
    }
    else{
        [quiz.assetUrls addObject:assetUrl];
    }
    
    [sub.quizzes addObject:quiz];
    [[Data sharedData] saveSubjectAtIndex:[btn getIndex] subject:sub];
}

@end
