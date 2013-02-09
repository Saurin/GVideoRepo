//
//  VideoViewController.m
//  GuidedVideo
//
//  Created by Sejal Pandya on 1/18/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "VideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>  
#define ButtonCount 16
#define VPadding 20
#define HPadding 40


@implementation VideoViewController {
    MPMoviePlayerController *moviePlayer;
    UIImageView *videoThumbnailImageView;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setTitle:@""];

    [self loadButtons];
    [self createButtons];

    [self playVideo];
}

-(void)viewWillDisappear:(BOOL)animated {
    [moviePlayer stop];
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
    
    NSInteger height = self.view.frame.size.height-buttonHeight*2-VPadding*4;
    NSInteger width = self.view.frame.size.width-buttonWidth*2-HPadding*4;
    
    CGRect frame = CGRectMake((self.view.frame.size.width-width)/2, (self.view.frame.size.height-height)/2, width, height);
    CustomButton *videoButton = [[CustomButton alloc] initWithFrame:frame];
    videoButton.tag=101;
    [self.view addSubview:videoButton];
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

-(void)playVideo {

    NSURL *url = [NSURL URLWithString:@"file://localhost/private/var/mobile/Applications/BF939F78-7435-4CC0-B26B-D24CA46C6944/tmp//trim.6vQI3c.MOV"];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [player prepareToPlay];
    
    CustomButton *videoButton = (CustomButton *)[self.view viewWithTag:101];
    [player.view setFrame:CGRectMake(0, 0, videoButton.frame.size.width, videoButton.frame.size.height)];
    [videoButton addSubview:player.view];
    
    player.controlStyle=MPMovieControlStyleNone;
    player.movieSourceType=MPMovieSourceTypeStreaming;
    player.repeatMode=MPMovieRepeatModeOne;
    player.scalingMode=MPMovieScalingModeAspectFill & MPMovieScalingModeAspectFit;
    moviePlayer=player;

    UIImage *videoThumbnail = [player thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    videoThumbnailImageView=[[UIImageView alloc] initWithImage:videoThumbnail];
    [videoThumbnailImageView setContentMode:UIViewContentModeScaleAspectFit];
    [videoThumbnailImageView setFrame:CGRectMake(0, 0, videoButton.frame.size.width, videoButton.frame.size.height)];
    [videoButton addSubview:videoThumbnailImageView];
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
    CFShow((__bridge CFTypeRef)([touch view]));
    
    for(NSInteger i=0;i<ButtonCount;i++){
        
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        if ([touch view] == btn ) {
            //take action
            return;
        }
    }

    if ([touch view] == [self.view viewWithTag:1001] ) {

        [videoThumbnailImageView setHidden:YES];
        [moviePlayer play];
        return;
        
    }
}

@end
