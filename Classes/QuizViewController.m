
#import "QuizViewController.h"
#import "QuizPage.h"
#import "QuizOption.h"
#import "Utility.h"

#define ButtonCount 12


@implementation QuizViewController {
    
    NSInteger quizPageIndex;

    double buttonHeight,buttonWidth,viewHeight, viewWidth;
    double vPadding, hPadding;

    
    NSMutableArray *quizzes;                        //all available quizzes for this topic
    QuizPage *theQuizPage;                          //current quiz page
    MPMoviePlayerController *moviePlayer;
    UIImageView *videoThumbnailImageView;
    
    NSInteger whatNext;
}

@synthesize subject;

-(void)viewDidLoad {

    [super viewDidLoad];
    [self addBrandText];
    quizzes = [[NSMutableArray alloc] init];
    
    //get all quizzes for this subject
    NSMutableArray *dirtyQuizzes = [[Data sharedData] getSubjectAtSubjectId:subject.subjectId].quizPages;
    for (NSInteger i=0; i<dirtyQuizzes.count; i++) {
        QuizPage *page = [dirtyQuizzes objectAtIndex:i];
        if([[Data sharedData] isQuizProgrammed:page.quizId])
            [quizzes addObject:page];
    }
    
    quizPageIndex=0;
    theQuizPage=nil;
    
    [self loadButtons];
    [self createButtons];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake)
	{
        [self dismissViewControllerAnimated:YES completion:^{
            //do nothing
        }];

	}
}

-(void)changeVideo:(NSString *)videoUrl {

    [moviePlayer stop];
    moviePlayer.contentURL = [NSURL URLWithString:videoUrl];
}

-(void)viewWillDisappear:(BOOL)animated {
    [moviePlayer stop];
    moviePlayer=nil;
}

-(void)loadButtons {

    if(buttonHeight==0){
        viewHeight=self.view.frame.size.height;
        viewWidth=self.view.frame.size.width;
        
        buttonHeight = 167;     
        buttonWidth = 222.6;    
        vPadding=(viewHeight-buttonHeight*4)/5;
        hPadding=(viewWidth-buttonWidth*4)/5;
    }

    theQuizPage=nil;
    for(NSInteger i=1;i<=ButtonCount;i++){
        [[self.view viewWithTag:i] removeFromSuperview];
    }
    [[self.view viewWithTag:101] removeFromSuperview];
    [moviePlayer stop];
    moviePlayer.contentURL=nil;
    
    
    NSInteger tag=1;
    //bottom row
    for(NSInteger i=0;i<4;i++){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*hPadding, viewHeight-buttonHeight-vPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setEditable:NO];
        
    }
    
    //right column
    for(NSInteger i=2;i>0;i--){
        
        CGRect frame = CGRectMake(viewWidth-buttonWidth-hPadding,(i*buttonHeight)+(i+1)*vPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setEditable:NO];
    }
    
    
    //top row
    for(NSInteger i=3;i>=0;i--){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*hPadding, vPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setEditable:NO];
    }
    
    //left column
    for(NSInteger i=1;i<=2;i++){
        
        CGRect frame = CGRectMake(hPadding,(i*buttonHeight)+(i+1)*vPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setEditable:NO];
    }
    
    NSInteger height = 350.25;      
    NSInteger width = 467;          
    
    CGRect frame = CGRectMake((viewWidth-width)/2, (viewHeight-height)/2, width, height);
    CustomButton *videoButton = [[CustomButton alloc] initWithFrame:frame];
    videoButton.tag=101;
    [self.view addSubview:videoButton];
}

-(void)createButtons {
    
    //set up video button
    CustomButton *videoButton = (CustomButton *)[self.view viewWithTag:101];
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
        
        NSMutableArray *options=theQuizPage.quizOptions;
        //now fill remaining buttons with empty values so that buttons get spread across screen
        NSInteger cnt=options.count;
        while (cnt<12) {
            [options addObject:[QuizOption alloc]];
            cnt++;
        }
        if(![[[Utility alloc] init] getUserSettings:[NSString stringWithFormat:@"Settings%d",200]]){
            options = [self randomizeButtons:options];
        }
        
        for(NSInteger i=0;i<ButtonCount;i++){
            QuizOption *option = [options objectAtIndex:i];
            if(option.quizId!=0){
                QuizOption *quiz = [options objectAtIndex:i];
                
                CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
                [btn createQuizButtonAtIndex:i+1 withQuiz:quiz];
                
                if(![quiz.assetUrl isEqualToString:@""]){
                    [btn addImageUsingAssetURL:quiz.assetUrl];
                }
            }
            else{
                
                CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
                [btn setFakeButton:YES];
            }
        }
    }
    
    //we ready to play, let kid play now
    whatNext=0;
}

-(void)addVideoPlayer:(NSString *)videoUrl {
    
    NSURL *url = [NSURL URLWithString:videoUrl];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [player prepareToPlay];
    
    CustomButton *videoButton = (CustomButton *)[self.view viewWithTag:101];
    [player.view setFrame:CGRectMake(0, 0, videoButton.frame.size.width, videoButton.frame.size.height)];
    [videoButton addSubview:player.view];
    
    if([[[Utility alloc] init] getUserSettings:[NSString stringWithFormat:@"Settings%d",0]]){
        player.controlStyle=MPMovieControlStyleEmbedded;
    }
    else{
        player.controlStyle=MPMovieControlStyleNone;
    }
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

            if([[[Utility alloc] init] getUserSettings:[NSString stringWithFormat:@"Settings%d",100]]){
                //allow to touch button and get new video....
            }
            else{
                if(whatNext!=0) return;         //ignore touch as response video getting played
            }
            
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
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
    
    if(whatNext==3){            //response video just played, pause it and play question video

        moviePlayer.controlStyle=MPMovieControlStyleEmbedded;

        whatNext=-1;                //we are preparing for next video, so lets not allow any touch
        theQuizPage=nil;
        [self loadButtons];
        [self createButtons];

        return;
    }
    
    if(whatNext==4){       //response video just played and need to take to next quiz
        whatNext=-1;                //we are preparing for next video, so lets not allow any touch

        if(quizPageIndex+1<quizzes.count){
            quizPageIndex++;
            
            theQuizPage=nil;
            [self loadButtons];
            [self createButtons];
        }
        else{           //no more quizzes left, take user back to list page
            [self dismissViewControllerAnimated:YES completion:^{
                //do nothing
            }];
        }
        return;
    }
}



@end
