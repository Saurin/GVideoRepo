
#import "BaseModelViewController.h"
#import <MediaPlayer/MediaPlayer.h>  
#import "CustomButton.h"
#import "Subject.h"
#import "Data.h"
#import "QuizView.h"

@interface PlayingViewController : BaseModelViewController <MPMediaPlayback, MPMediaPickerControllerDelegate>

@property (nonatomic) Subject *subject;
@property (nonatomic, strong) QuizView *mainView;

@end
