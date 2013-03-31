

#import "BaseViewController.h"
#import "SelectionChangeDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlternativeViewController : BaseViewController<SubstitutableDetailViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate>


@property BOOL isDetailController;

@property (nonatomic, strong) QuizOption *quizOption;
@property (nonatomic, strong) UITextField *txtOptionName;
@property (nonatomic, strong) IBOutlet UITableView *tblImageFrom;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) UIImageView *imgCurrent;
@property (nonatomic, strong) UIImageView *imgVideoCurrent;
@property (nonatomic, strong) id<SelectionChangeDelegate> delegate;

-(IBAction)didOptionDeleteClick:(id)sender;
-(BOOL)didOptionSelectionChange:(QuizOption *)newOption;

@end
