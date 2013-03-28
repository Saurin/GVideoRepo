//
//  InstructionListViewController.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 3/27/13.
//
//

#import "BaseViewController.h"

@interface InstructionListViewController : BaseViewController<SubstitutableDetailViewController>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Subject *thisSubject;
@property BOOL isListDetailController;


@end
