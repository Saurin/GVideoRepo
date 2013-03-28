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
#import "OHAlertView.h"
#import "MBProgressHUD.h"

#define ButtonCount 12
#define VPadding 20
#define HPadding 40

@implementation QuizEditViewController {
    QuizView *mainView;
    MBProgressHUD *hud;
    
    NSInteger quizPageIndex;
    UIActionSheet *normalActionSheet;
    
    NSMutableArray *quizzes;                        //all available quizzes for this topic
    QuizPage *theQuizPage;                          //current quiz page
    MPMoviePlayerController *moviePlayer;
    UIImageView *videoThumbnailImageView;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    quizPageIndex=0;
}

-(void)viewWillAppear:(BOOL)animated {
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];

    [self loadButtons];
    [self createButtons];
    [self addNavigationButtons];
    [hud hide:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [moviePlayer stop];
    moviePlayer=nil;
}

-(BOOL)isEditableButtonAtTag:(NSInteger)tag {
    return YES;
}

-(void)loadButtons {

//    [mainView redraw];
    theQuizPage=nil;
    for(NSInteger i=1;i<=ButtonCount;i++){
        [[self.view viewWithTag:i] removeFromSuperview];
    }
    [[self.view viewWithTag:101] removeFromSuperview];
    [moviePlayer stop];
    moviePlayer.contentURL=nil;
    
    
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

    //get all quizzes for this subject
    quizzes = [[Data sharedData] getSubjectAtSubjectId:self.subject.subjectId].quizPages;
    if(quizzes!=nil && quizzes.count>quizPageIndex)                     //get current quiz page
    {
        theQuizPage = [quizzes objectAtIndex:quizPageIndex];
        
        //we have video for current quiz, display it
        videoUrl = theQuizPage.videoUrl;
        if(videoUrl!=nil && ![videoUrl isEqualToString:@""]){
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
            
            if(quiz.videoUrl==nil || [quiz.videoUrl isEqualToString:@""])
                [btn showIncomplete];
            
            [btn setHidden:NO];
        }
    }
    
    if(videoUrl!=NULL && ![videoUrl isEqualToString:@""]){    //before adding any option, adding video is needed as that generates quiz id
        
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:theQuizPage.quizOptions.count+1];
        [btn createQuizButtonAtIndex:theQuizPage.quizOptions.count+1 withQuiz:nil];
        [btn addNewButton];
        [btn setHidden:NO];
    }
}

-(void)addVideoPlayer:(NSString *)videoUrl {
    
    if(moviePlayer==nil){
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] init];
        player.controlStyle=MPMovieControlStyleEmbedded;
        player.movieSourceType=MPMovieSourceTypeStreaming;
        player.shouldAutoplay=NO;
        player.scalingMode=MPMovieScalingModeAspectFill & MPMovieScalingModeAspectFit;
        moviePlayer=player;
    }

    moviePlayer.contentURL = [NSURL URLWithString:videoUrl];
    [moviePlayer prepareToPlay];
    CustomButton *videoButton = (CustomButton *)[self.view viewWithTag:101];
    [moviePlayer.view setFrame:CGRectMake(0, 0, videoButton.frame.size.width, videoButton.frame.size.height)];
    [videoButton addSubview:moviePlayer.view];
}

-(void)addNavigationButtons {
    
    UIActionSheet *actionSheet;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Delete Quiz"
                                         otherButtonTitles:@"Add a New Quiz", @"Previous Quiz", @"Next Quiz", @"Copy to New Quiz", nil];
    normalActionSheet = actionSheet;

    if(quizPageIndex+1>quizzes.count){
        self.title = @"Add Video & Answers for Quiz - New Answer";
    }
    else{
        self.title = [NSString stringWithFormat:@"Add Video & Answers for Quiz - %d of %d", quizPageIndex+1, quizzes.count==0?1:quizzes.count];
    }
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
    
    if([touch view]==[videoThumbnailImageView viewForBaselineLayout] || [touch view]==[moviePlayer view]){
        [videoThumbnailImageView setHidden:YES];
        [moviePlayer play];
    }
}

-(IBAction)didActionClick:(id)sender {
    [normalActionSheet showFromBarButtonItem:self.buttonAction animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            
            [self performSelector:@selector(deleteQuiz:) withObject:nil afterDelay:0.2];
            break;
        }
            
        case 1: {
            
            [self performSelector:@selector(addNewQuiz:) withObject:nil afterDelay:0.2];
            break;
        }
            
        case 2: {
            
            [self performSelector:@selector(previousQuiz:) withObject:nil afterDelay:0.2];
            break;
        }

        case 3: {

            [self performSelector:@selector(nextQuiz:) withObject:nil afterDelay:0.2];
            break;
        }

        case 4: {
            
            [self performSelector:@selector(copyQuiz:) withObject:nil afterDelay:0.2];
            break;
            
        }
        default:
            break;
    }
    
    [normalActionSheet dismissWithClickedButtonIndex:5 animated:YES];;
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView* view in [actionSheet subviews])
    {
        if ([view isKindOfClass:NSClassFromString(@"UIAlertButton")])
        {
            if ([view respondsToSelector:@selector(title)])
            {
                NSString* title = [view performSelector:@selector(title)];
                
                if(quizPageIndex+1>quizzes.count &&
                   ([title isEqualToString:@"Delete Quiz"] || [title isEqualToString:@"Add a New Quiz"]
                    || [title isEqualToString:@"Next Quiz"] || [title isEqualToString:@"Copy to New Quiz"]))
                {
                    [view setBackgroundColor:[UIColor grayColor]];
                    [view setAlpha:0.2];
                    [view setUserInteractionEnabled:NO];
                }
                
                if((quizPageIndex==0 && [title isEqualToString:@"Previous Quiz"])
                   || (quizPageIndex==quizzes.count-1 && [title isEqualToString:@"Next Quiz"]))
                {
                    [view setBackgroundColor:[UIColor grayColor]];
                    [view setAlpha:0.2];
                    [view setUserInteractionEnabled:NO];
                }
                
            }
        }
    }
}


-(IBAction)addNewQuiz:(id)sender {

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    quizPageIndex=quizzes.count;
    [self loadButtons];

    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        
                    }
                    completion:^(BOOL finished) {
                        [self createButtons];
                        [self addNavigationButtons];
                        [hud hide:YES];
                    }];

}

-(IBAction)nextQuiz:(id)sender {

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    quizPageIndex++;
    [self loadButtons];

    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        
                    }
                    completion:^(BOOL finished) {
                        [self createButtons];
                        [self addNavigationButtons];
                        [hud hide:YES];
                    }];
}

-(IBAction)previousQuiz:(id)sender {
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    quizPageIndex--;
    [self loadButtons];

    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        
                    }
                    completion:^(BOOL finished) {
                        [self createButtons];
                        [self addNavigationButtons];
                        [hud hide:YES];
                    }];
    
}

-(IBAction)deleteQuiz:(id)sender {
    
    [OHAlertView showAlertWithTitle:@"Delete Quiz" message:@"Are you sure you want to delete this quiz?" cancelButton:@"Cancel" okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex == 1) {

            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud show:YES];
            [[Data sharedData] deleteQuizWithQuizId:theQuizPage.quizId];
            
            quizPageIndex=0;
            [self loadButtons];
            [self createButtons];
            [self addNavigationButtons];
            [hud hide:YES];
        }
    }];
}

-(IBAction)copyQuiz:(id)sender {
    
    [OHAlertView showAlertWithTitle:@"" message:@"Are you sure you want to copy and leave this quiz?" cancelButton:@"Cancel" okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            
            //insert new quizpage
            QuizPage *newQuizPage = [[QuizPage alloc] init];
            newQuizPage.subjectId=self.subject.subjectId;
            newQuizPage.videoUrl=theQuizPage.videoUrl;
            [[Data sharedData] saveQuiz:newQuizPage];

            //get recently added quizpage
            NSMutableArray *pages=[[Data sharedData] getSubjectAtSubjectId:self.subject.subjectId].quizPages;
            QuizPage *page = [pages objectAtIndex:pages.count-1];
            //insert quiz answers for recently added quizpage
            for(NSInteger j=0;j<theQuizPage.quizOptions.count;j++){
                QuizOption *option = (QuizOption *)[theQuizPage.quizOptions objectAtIndex:j];
                
                QuizOption *insertOption = [[QuizOption alloc] init];
                insertOption.quizOptionId=0;
                insertOption.quizId = page.quizId;
                insertOption.assetUrl=option.assetUrl;
                insertOption.videoUrl=option.videoUrl;
                insertOption.response=option.response;
                [[Data sharedData] saveQuizOption:insertOption];
            }
            
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud show:YES];
            quizPageIndex=quizzes.count;
            [self loadButtons];

            [UIView transitionWithView:self.view
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCurlUp
                            animations:^{
                                
                            }
                            completion:^(BOOL finished) {
                                [self createButtons];
                                [self addNavigationButtons];
                                [hud hide:YES];
                            }];

            
            [[[UIAlertView alloc] initWithTitle:@"" message:@"New Quiz created" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
    }];
}

-(void)saveVideoUrlForButton:(CustomButton *)btn videoUrl:(NSString *)urlString {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    
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
        
        [self addNewQuiz:nil];
        [self previousQuiz:nil];
    }
    [hud hide:YES];
}

-(void)saveQuizButton:(CustomButton *)btn withQuizOption:(QuizOption *)quizOption {
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    
    quizOption.quizId = theQuizPage.quizId;
    [[Data sharedData] saveQuizOption:quizOption];
    
    [self loadButtons];
    [self createButtons];
    
    [hud hide:YES];
}

-(void)removeQuizButton:(CustomButton *)btn withQuizOption:(QuizOption *)quizOption {

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    
    [[Data sharedData] deleteQuizOptionWithId:quizOption.quizOptionId];
    
    [self loadButtons];
    [self createButtons];
    
    [hud hide:YES];
}

@end
