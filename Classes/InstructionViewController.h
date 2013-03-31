
#import "BaseViewController.h"
#import "SelectionChangeDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface InstructionViewController : BaseViewController<SubstitutableDetailViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property BOOL isDetailController;

@property (nonatomic, strong) QuizPage *thisQuiz;
@property (nonatomic, strong) UITextField *txtQuizName;
@property (nonatomic, strong) IBOutlet UITableView *tblVideoFrom;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) UIImageView *imgCurrentVideo;
@property (nonatomic, strong) id<SelectionChangeDelegate> delegate;

-(IBAction)didQuizDeleteClick:(id)sender;
-(BOOL)didQuizSelectionChange:(QuizPage *)newQuiz;
@end
