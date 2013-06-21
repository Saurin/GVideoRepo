

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SubjectViewController.h"
#import "MenuTableViewController.h"
#import "SelectionChangeDelegate.h"
#import "ImageCell.h"

@interface SubjectListViewController : BaseViewController <SubstitutableDetailViewController, SelectionChangeDelegate, ImageCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isListDetailController;

@end

