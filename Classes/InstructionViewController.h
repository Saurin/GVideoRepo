
#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface InstructionViewController : BaseViewController<SubstitutableDetailViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property BOOL isDetailController;

@property (nonatomic, strong) QuizPage *thisQuiz;
@property (nonatomic, strong) UITextField *txtQuizName;
@property (nonatomic, strong) IBOutlet UITableView *tblVideoFrom;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) UIImageView *imgCurrentVideo;

-(IBAction)didQuizDeleteClick:(id)sender;
@end
