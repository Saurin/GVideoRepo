//
//  QuizEditViewController.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/2/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "QuizEditViewController.h"
#import "QuizPage.h"
#import "QuizOption.h"
#define ButtonCount 12
#define VPadding 20
#define HPadding 40

@implementation QuizEditViewController {
    NSInteger quizPageIndex;
    
    NSMutableArray *quizzes;                        //all available quizzes for this topic
    QuizPage *theQuizPage;                          //current quiz page
    MPMoviePlayerController *moviePlayer;
    UIImageView *videoThumbnailImageView;
}

-(void)viewDidLoad {
    
    //get all quizzes for this subject
    quizzes = [[Data sharedData] getSubjectAtSubjectId:self.subject.subjectId].quizPages;
    
    quizPageIndex=0;
    [self loadButtons];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self createButtons];
    [self addNavigationButtons];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)loadButtons {
    
    for (UIView* v in self.view.subviews) {
        [v removeFromSuperview];
    }
    theQuizPage=nil;
    
    
    NSInteger tag=1;
    NSInteger buttonCount = ButtonCount/4+1;
    double buttonHeight = (self.view.frame.size.height-VPadding*(buttonCount+1))/buttonCount;
    double buttonWidth = (self.view.frame.size.width-HPadding*(buttonCount+1))/buttonCount;
    
    //bottom row
    for(NSInteger i=0;i<4;i++){
        
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
    for(NSInteger i=2;i>0;i--){
        
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
    for(NSInteger i=3;i>=0;i--){
        
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
    for(NSInteger i=1;i<=2;i++){
        
        CGRect frame = CGRectMake(HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
        [btn setEditable:YES];
        btn.delegate=self;
        btn.presentingController=self;
    }
    
    NSInteger height = self.view.frame.size.height-buttonHeight*2-VPadding*4;
    NSInteger width = self.view.frame.size.width-buttonWidth*2-HPadding*4;
    
    CGRect frame = CGRectMake((self.view.frame.size.width-width)/2, (self.view.frame.size.height-height)/2, width, height);
    CustomButton *videoButton = [[CustomButton alloc] initWithFrame:frame];
    videoButton.tag=101;
    [self.view addSubview:videoButton];
    
}

-(void)createButtons {
    
    //set up video button
    CustomButton *videoButton = (CustomButton *)[self.view viewWithTag:101];
    [videoButton createButtonAtIndex:101];
    [videoButton setEditable:YES];
    
    videoButton.delegate=self;
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
        
        for(NSInteger i=0;i<theQuizPage.quizOptions.count;i++){
            
            QuizOption *quiz = [theQuizPage.quizOptions objectAtIndex:i];
            NSLog(@"%d %@ %@, %d",quiz.quizId, quiz.assetUrl, quiz.videoUrl, quiz.response);
            CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
            [btn createQuizButtonAtIndex:i+1 withQuiz:quiz];
            
            if(![quiz.assetUrl isEqualToString:@""]){
                [btn addImageUsingAssetURL:quiz.assetUrl];
            }
            
            [btn setHidden:NO];
        }
    }
    
    if(![videoUrl isEqualToString:@""]){    //before adding any option, adding video is needed as that generates quiz id
        
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:theQuizPage.quizOptions.count+1];
        [btn createQuizButtonAtIndex:theQuizPage.quizOptions.count+1 withQuiz:nil];
        [btn addNewButton];
        [btn setHidden:NO];
    }
}

-(void)addVideoPlayer:(NSString *)videoUrl {
    
    NSURL *url = [NSURL URLWithString:videoUrl];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [player prepareToPlay];
    
    CustomButton *videoButton = (CustomButton *)[self.view viewWithTag:101];
    [player.view setFrame:CGRectMake(0, 0, videoButton.frame.size.width, videoButton.frame.size.height)];
    [videoButton addSubview:player.view];
    
    player.controlStyle=MPMovieControlStyleEmbedded;
    player.movieSourceType=MPMovieSourceTypeStreaming;
    player.shouldAutoplay=NO;
    player.scalingMode=MPMovieScalingModeAspectFill & MPMovieScalingModeAspectFit;
    moviePlayer=player;
    
    //    UIImage *videoThumbnail = [player thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    //    videoThumbnailImageView=[[UIImageView alloc] initWithImage:videoThumbnail];
    //    [videoThumbnailImageView setContentMode:UIViewContentModeScaleAspectFit];
    //    [videoThumbnailImageView setFrame:CGRectMake(0, 0, videoButton.frame.size.width, videoButton.frame.size.height)];
    //    [videoButton addSubview:videoThumbnailImageView];
}

-(void)addNavigationButtons {
    
    if(quizPageIndex==0){
        UIBarButtonItem *Button2 = [[UIBarButtonItem alloc] initWithTitle:@"Next Quiz" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(addNewQuiz:)] ;
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:Button2, nil];
        
    }
    else{
        UIBarButtonItem *Button1 = [[UIBarButtonItem alloc]initWithTitle:@"Previous Quiz" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(previousQuiz:)] ;
        
        UIBarButtonItem *Button2 = [[UIBarButtonItem alloc] initWithTitle:@"Next Quiz" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(addNewQuiz:)] ;
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:Button2, Button1, nil];
    }
    
    self.title = [NSString stringWithFormat:@"Add Video & Answers for Quiz - %d of %d", quizPageIndex+1, quizzes.count==0?1:quizzes.count];
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
            break;
        }
    }
}

-(IBAction)addNewQuiz:(id)sender {
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        quizPageIndex++;
                        [self loadButtons];
                        [self createButtons];
                        [self addNavigationButtons];
                    }
                    completion:NULL];
}

-(IBAction)previousQuiz:(id)sender {
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        quizPageIndex--;
                        [self loadButtons];
                        [self createButtons];
                        [self addNavigationButtons];
                    }
                    completion:NULL];
    
}

-(void)saveVideoUrlForButton:(CustomButton *)btn videoUrl:(NSString *)urlString {
    
    if(btn.buttonType==CustomButtonTypeQuiz){
        
        QuizOption *quizOption = [btn getQuizOption];
        quizOption.videoUrl = urlString;
        quizOption.response = [btn getButtonChoice];
        
        NSLog(@"%d %@ %@, %d",quizOption.quizOptionId, quizOption.assetUrl, quizOption.videoUrl, quizOption.response);
        
        [[Data sharedData] saveQuizOption:quizOption];
        
        [self loadButtons];
        [self createButtons];
        
    }
    else{
        if(theQuizPage==nil)                            //if current quiz page is a new one
            theQuizPage = [[QuizPage alloc] init];
        
        theQuizPage.subjectId=self.subject.subjectId;
        theQuizPage.videoUrl=urlString;
        
        [[Data sharedData] saveQuiz:theQuizPage];
        
        [self loadButtons];
        [self createButtons];
    }
}

-(void)saveQuizButton:(CustomButton *)btn withQuizOption:(QuizOption *)quizOption {
    NSLog(@"%d %@",quizOption.quizOptionId, quizOption.assetUrl);
    
    quizOption.quizId = theQuizPage.quizId;
    [[Data sharedData] saveQuizOption:quizOption];
    
    [self loadButtons];
    [self createButtons];
}

-(void)removeQuizButton:(CustomButton *)btn withQuizOption:(QuizOption *)quizOption {
    NSLog(@"%d %@",quizOption.quizOptionId, quizOption.assetUrl);
}

@end
