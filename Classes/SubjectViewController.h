

#import "BaseViewController.h"
#import "InstructionListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SubjectViewController : BaseViewController <SubstitutableDetailViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property BOOL isDetailController;

@property (nonatomic, strong) Subject *thisSubject;
@property (nonatomic, strong) UITextField *txtSubject;
@property (nonatomic, strong) IBOutlet UITableView *tblImageFrom;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) UIImageView *imgCurrent;
@property (nonatomic, strong) id<SelectionChangeDelegate> delegate;

-(IBAction)didSubjectDeleteClick:(id)sender;
-(BOOL)didSubjectSelectionChange:(Subject *)newSubject;

@end
