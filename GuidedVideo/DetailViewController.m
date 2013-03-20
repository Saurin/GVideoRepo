

#import "DetailViewController.h"

@implementation DetailViewController {
    NSMutableArray *options;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectedValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"SelectedValue"
                                               object:nil];
    
    self.feedbackArray = [NSMutableArray arrayWithObjects:@"Rate This App", @"How to Write Review", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the detail item

- (void) receiveNotification:(NSNotification *) notification
{
    NSString *name = [notification name];
    if ([name isEqualToString:@"SelectedValue"]) {
        
        NSString *object = [notification object];
        self.title = object;
        
        options = [[NSMutableArray alloc] init];
        if ([object isEqualToString:@"Tutorial"]){
            
        }
        else if ([object isEqualToString:@"Feedback"]){
            options = [self.feedbackArray copy];
        }
        
        [self.table reloadData];
    }
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text=[options objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark SubstitutableDetailViewController

//- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
//{
//    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
//        if (navigationPaneBarButtonItem)
//            [self.toolbar setItems:[NSArray arrayWithObject:navigationPaneBarButtonItem] animated:NO];
//        else
//            [self.toolbar setItems:nil animated:NO];
//        
//        [_navigationPaneBarButtonItem release];
//        _navigationPaneBarButtonItem = [navigationPaneBarButtonItem retain];
//    }
//}

@end
