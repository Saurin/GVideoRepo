

#import "SubjectListViewController.h"
#import <objc/runtime.h>

static char * const myIndexPathAssociationKey = "";
@implementation SubjectListViewController {
    NSMutableArray *subjects;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Configure Me";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    subjects = [[Data sharedData] getSubjects];
    Subject *sub = [[Subject alloc] init];
    sub.subjectId=-1;
    sub.subjectName=@"Add Subject...";
    [subjects addObject:sub];
    
    [self.tableView setRowHeight:60];
    [self.tableView reloadData];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
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

        if(thisSubject.assetUrl!=nil){
            [[Utility alloc] setImageFromAssetURL:thisSubject.assetUrl completion:^(NSString *url, UIImage *image) {

                // Code to actually update the cell once the image is obtained must be run on the main queue.
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *cellIndexPath = (NSIndexPath *)objc_getAssociatedObject(cell, myIndexPathAssociationKey);
                    if ([indexPath isEqual:cellIndexPath]) {
                        // Only set cell image if the cell currently being displayed is the one that actually required this image.
                        // Prevents reused cells from receiving images back from rendering that were requested for that cell in a previous life.
                        [cell.imageView setFrame:CGRectMake(10, 10, 30, 30)];
                        [cell.imageView setImage:image];
                        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill | UIViewContentModeScaleAspectFit];
                        
                        //to force to display image
                        [cell setEditing:YES];
                        [cell setEditing:NO];
                    }
                });
            }];
        }
    });
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showSubject" sender:nil];
}

@end
