//
//  TopicsViewController.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "TopicsViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#define ButtonCount 16
#define VPadding 20
#define HPadding 40

@implementation TopicsViewController {

}


-(void)viewWillAppear:(BOOL)animated {
    
    [self setTitle:@""];
    
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
    [[self.view viewWithTag:101] removeFromSuperview];
    
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
}

-(void)createButtons {
    
    NSMutableArray *buttons = [[Data sharedData] getSubjects];
    
    for(NSInteger i=0;i<ButtonCount;i++){
        
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        [btn createButtonAtIndex:i];
        [btn setEditable:NO];
        
        btn.presentingController=self;
        btn.buttonType=CustomButtonTypeSubject;
        
        if(buttons.count>i){
            
            Subject *sub = [buttons objectAtIndex:i];
            if(![sub.subjectName isEqualToString:@""]){
                [btn addText:sub.subjectName];
            }
            if(![sub.assetUrl isEqualToString:@""]){
                [btn addImageUsingAssetURL:sub.assetUrl];
            }
            btn.bEmptyButton=NO;
            [btn setHidden:NO];
        }
        else{
            btn.bEmptyButton=YES;
            [btn setHidden:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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
            //take action
            return;
        }
    }
}

@end
