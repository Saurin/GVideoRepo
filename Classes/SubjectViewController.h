

#import "BaseViewController.h"
#import "QuizEditViewController.h"
#import "DetailViewManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SubjectViewChangeDelegate.h"

@interface SubjectViewController : BaseViewController <SubstitutableDetailViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) Subject *thisSubject;
@property (nonatomic, strong) UITextField *txtSubject;
@property (nonatomic, strong) IBOutlet UITableView *tblImageFrom;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) UIImageView *imgCurrent;
@property (nonatomic, strong) id<SubjectViewChangeDelegate> delegate;
-(IBAction)didSubjectDeleteClick:(id)sender;
-(BOOL)didSubjectSelectionChange:(Subject *)newSubject;
@end
