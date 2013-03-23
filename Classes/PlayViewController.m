

#import "PlayViewController.h"
#import <objc/runtime.h>
#import "ImageCell.h"
#import "AppDelegate.h"

static char * const myIndexPathAssociationKey = "";
@implementation PlayViewController {
    NSMutableArray *subjects;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;

    subjects = [[Data sharedData] getSubjects];
    
    [self.tableView setRowHeight:75];
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
	
    // Get a reference to the DetailViewManager.
    // DetailViewManager is the delegate of our split view.
    DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
    [detailViewManager.masterViewController.view setFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [subjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //dont want to reuse cell as we have cell image getting added on a different queue
    ImageCell *cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Subject *thisSubject = [subjects objectAtIndex:indexPath.row];
    cell.textLabel.text = thisSubject.subjectName;
    cell.tag = thisSubject.subjectId;
    
    // Store a reference to the current cell that will enable the image to be associated with the correct
    // cell, when the image subsequently loaded asynchronously. Without this, the image may be mis-applied
    // to a cell that has been dequeued and reused for other content, during rapid scrolling.
    objc_setAssociatedObject(cell, myIndexPathAssociationKey, indexPath, OBJC_ASSOCIATION_ASSIGN);
    
    // Load the image on a high priority background queue using Grand Central Dispatch.
    // Can change priority by replacing HIGH with DEFAULT or LOW if desired.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        
        [[Utility alloc] setImageFromAssetURL:thisSubject.assetUrl completion:^(NSString *url, UIImage *image) {
            
            // Code to actually update the cell once the image is obtained must be run on the main queue.
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *cellIndexPath = (NSIndexPath *)objc_getAssociatedObject(cell, myIndexPathAssociationKey);
                if ([indexPath isEqual:cellIndexPath]) {
                    // Only set cell image if the cell currently being displayed is the one that actually required this image.
                    // Prevents reused cells from receiving images back from rendering that were requested for that cell in a previous life.
                    
                    [cell.imageView setImage:image];
                    
                    //to force to display image
                    [cell setEditing:YES];
                    [cell setEditing:NO];
                }
            });
        }];
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuizViewController *quizVC = [[QuizViewController alloc] initWithNibName:@"QuizView" bundle:nil];
    quizVC.subject = [subjects objectAtIndex:indexPath.row];
    [self presentModalViewController:quizVC animated:YES];
}


@end
