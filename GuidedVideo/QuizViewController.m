//
//  QuizViewController.m
//  GuidedVideo
//
//  Created by Mark Wade on 1/13/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "QuizViewController.h"
#import "QuizPage.h"
#import "QuizOption.h"
#define ButtonCount 12

@implementation QuizViewController {
    
    NSInteger quizPageIndex;

    NSMutableArray *quizzes;                        //all available quizzes for this topic
    QuizPage *theQuizPage;                          //current quiz page
    MPMoviePlayerController *moviePlayer;
    UIImageView *videoThumbnailImageView;
    
    NSInteger whatNext;
}

@synthesize subject;

-(void)viewDidLoad {

    self.mainView = (QuizView *)self.view;
    
    //get all quizzes for this subject
    quizzes = [[Data sharedData] getSubjectAtSubjectId:subject.subjectId].quizPages;
    
}

-(void)changeVideo:(NSString *)videoUrl {

    [moviePlayer stop];
    moviePlayer.contentURL = [NSURL URLWithString:videoUrl];
}

-(void)viewWillAppear:(BOOL)animated {
    
    quizPageIndex=0;
    theQuizPage=nil;
    [self createButtons];
}

-(void)viewWillDisappear:(BOOL)animated {
    [moviePlayer stop];
    moviePlayer=nil;
}

-(void)createButtons {
    
    //set up video button
    CustomButton *videoButton = (CustomButton *)[self.mainView viewWithTag:101];
    [videoButton createButtonAtIndex:101];
    [videoButton setEditable:NO];
    
    videoButton.presentingController=self;
    videoButton.buttonType=CustomButtonTypeVideo;

    NSString *videoUrl;
    if(quizzes!=nil && quizzes.count>quizPageIndex)                     //get current quiz page
    {
        theQuizPage = [quizzes objectAtIndex:quizPageIndex];
        
        //we have video for current quiz, display it
        videoUrl = theQuizPage.videoUrl;
        if(![videoUrl isEqualToString:@""]){
            [self addVideoPlayer:videoUrl];
        }
    }
    
    //set up quiz answer buttons
    if(quizzes!=nil && quizzes.count>quizPageIndex)                     //get current quiz page
    {
        theQuizPage = [quizzes objectAtIndex:quizPageIndex];
        theQuizPage.quizOptions=[[Data sharedData] getQuizOptionsForQuizId:theQuizPage.quizId];
        
        NSMutableArray *options = [self randomizeButtons:theQuizPage.quizOptions];
        for(NSInteger i=0;i<options.count;i++){
            
            QuizOption *quiz = [options objectAtIndex:i];
            
            CustomButton *btn = (CustomButton *)[self.mainView viewWithTag:i+1];
            [btn createQuizButtonAtIndex:i+1 withQuiz:quiz];
            
            if(![quiz.assetUrl isEqualToString:@""]){
                [btn addImageUsingAssetURL:quiz.assetUrl];
            }
            
            [btn setHidden:NO];
        }
    }
    
    //we ready to play, let kid play now
    whatNext=0;
}

-(void)addVideoPlayer:(NSString *)videoUrl {
    
    NSURL *url = [NSURL URLWithString:videoUrl];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [player prepareToPlay];
    
    CustomButton *videoButton = (CustomButton *)[self.mainView viewWithTag:101];
    [player.view setFrame:CGRectMake(0, 0, videoButton.frame.size.width, videoButton.frame.size.height)];
    [videoButton addSubview:player.view];
    
    player.controlStyle=MPMovieControlStyleEmbedded;
    player.movieSourceType=MPMovieSourceTypeStreaming;
    player.shouldAutoplay=YES;
    player.scalingMode=MPMovieScalingModeAspectFill & MPMovieScalingModeAspectFit;
    moviePlayer=player;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)playVideo {
    [moviePlayer play];
}

-(NSMutableArray *)randomizeButtons:(NSMutableArray *)options {

    NSUInteger firstObject = 0;

    for (int i = 0; i<[options count];i++) {
        NSUInteger randomIndex = random() % [options count];
        [options exchangeObjectAtIndex:firstObject withObjectAtIndex:randomIndex];
        firstObject +=1;
    }

    return options;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    for(NSInteger i=0;i<ButtonCount;i++){
        CustomButton *btn = (CustomButton *)[self.mainView viewWithTag:i+1];
        if ([touch view] == btn) {
            
            [btn setAlpha:.6];
            break;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    for(NSInteger i=0;i<ButtonCount;i++){
        
        CustomButton *btn = (CustomButton *)[self.mainView viewWithTag:i+1];
        if ([touch view] == btn) {
            
            [btn setAlpha:1];

            if(whatNext!=0) return;         //ignore touch as response video getting played
            
            [moviePlayer stop];         //button touched so should end current video
            
            //validate answer and take necessary action
            QuizOption* option = [btn getQuizOption];
            if(option.response==5)                      //play video and end quiz
            {
                [self changeVideo:option.videoUrl];
                moviePlayer.controlStyle=MPMovieControlStyleNone;
                whatNext=5;
                [self playVideo];
            }
            else if(option.response==3){                //play video and repeat quiz
                [self changeVideo:option.videoUrl];
                moviePlayer.controlStyle=MPMovieControlStyleNone;
                whatNext=3;
                [self playVideo];
            }
            else if(option.response==4){                //play video and next quiz
                [self changeVideo:option.videoUrl];
                moviePlayer.controlStyle=MPMovieControlStyleNone;
                whatNext=4;
                [self playVideo];
            }
            else
                whatNext=0;
            break;
        }
    }
}

-(void)videoPlayBackDidFinish:(NSNotification *)notification
{
    if(whatNext==5){       //need to end quiz on response of response video
        whatNext=-1;
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    if(whatNext==3){            //response video just played, pause it and play question video

        //[self changeVideo:theQuizPage.videoUrl];
        moviePlayer.controlStyle=MPMovieControlStyleEmbedded;

        whatNext=-1;                //we are preparing for next video, so lets not allow any touch
        theQuizPage=nil;
        [self.mainView redraw];
        [self createButtons];


        return;
    }
    
    if(whatNext==4){       //response video just played and need to take to next quiz
        //[self performSelector:@selector(nextQuiz) withObject:nil afterDelay:1];

        quizPageIndex++;
        
        whatNext=-1;                //we are preparing for next video, so lets not allow any touch
        theQuizPage=nil;
        [self.mainView redraw];
        [self createButtons];
                
        return;
    }
}



@end
