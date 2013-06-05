//
//  ContentListViewController.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 6/3/13.
//
//

#import "BaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ContentListViewController : BaseViewController <SubstitutableDetailViewController>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain) MPMoviePlayerController *moviePlayerController;
@end
