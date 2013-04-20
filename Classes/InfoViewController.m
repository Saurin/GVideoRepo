

#import "InfoViewController.h"

@implementation InfoViewController {
    Help *help;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.view addSubview:toolbar];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didDoneClick:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items=[NSArray arrayWithObjects:space,done, nil];
    
    @try {
        NSMutableArray *helpArray = ((AppDelegate *)[UIApplication sharedApplication].delegate).helpArray;
        help=(Help *)[[helpArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name=%@",self.sender]] objectAtIndex:0];
    }
    @catch (NSException *exception) {
        help = [[Help alloc] initWithName:@"" purpose:@"" section:@"" action:@"" exit:@""];
    }

    self.tableView.separatorColor=[UIColor clearColor];
}

-(void)viewDidUnload {
    self.tableView=nil;
    self.sender=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)didDoneClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [help.getHelpTopic count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    cell.textLabel.text = [help.getHelpTitle objectAtIndex:indexPath.row];
    cell.detailTextLabel.numberOfLines=0;
    cell.detailTextLabel.text = [help.getHelpTopic objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *cellFont = [UIFont systemFontOfSize:15];
    CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);

    NSString *cellText = [help.getHelpTitle objectAtIndex:indexPath.row];
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    cellText = [help.getHelpTopic objectAtIndex:indexPath.row];
    constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize labelDetailSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height+30+labelDetailSize.height;
}

@end
