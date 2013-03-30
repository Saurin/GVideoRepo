
#import "PreviewViewController.h"
#import <MediaPlayer/MediaPlayer.h>  


@implementation PreviewViewController {
    MPMoviePlayerController *moviePlayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor clearColor];
    [self.view setOpaque:NO];
    [self.view setAlpha:0.3];
    
    [self addVideoPlayer:self.videoUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload {
    [super viewDidUnload];
    moviePlayer=nil;
}

-(void)addVideoPlayer:(NSString *)videoUrl {
    
    NSURL *url = [NSURL URLWithString:videoUrl];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [player prepareToPlay];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen);
    CGFloat height = CGRectGetHeight(screen);

    [player.view setFrame:CGRectMake(0, 0, width-200, height-100)];
    [player.view setAlpha:1];
    [self.view addSubview:player.view];
    
    player.controlStyle=MPMovieControlStyleEmbedded;
    player.movieSourceType=MPMovieSourceTypeStreaming;
    player.shouldAutoplay=NO;
    player.scalingMode=MPMovieScalingModeAspectFill & MPMovieScalingModeAspectFit;
    moviePlayer=player;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)videoPlayBackDidFinish:(NSNotification *)notification {
    [self.view removeFromSuperview];
}

-(IBAction)click:(id)sender {

}

@end
