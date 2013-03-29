//
//  PreviewViewController.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 3/28/13.
//
//

#import "PreviewViewController.h"
#import <MediaPlayer/MediaPlayer.h>  


@implementation PreviewViewController {
    UIView *playerView;
    MPMoviePlayerController *player;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor clearColor];
    [self.view setOpaque:NO];
    
    playerView = [self.view viewWithTag:1];

    NSURL *url = [NSURL URLWithString:self.videoUrl];
    MPMoviePlayerController *p = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [p prepareToPlay];

    [playerView addSubview:player.view];

    p.controlStyle=MPMovieControlStyleEmbedded;
    p.movieSourceType=MPMovieSourceTypeStreaming;
    p.shouldAutoplay=YES;
    p.scalingMode=MPMovieScalingModeAspectFill & MPMovieScalingModeAspectFit;
    player=p;
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)click:(id)sender {
    [self.view removeFromSuperview];
}

@end
