

#import "SettingsViewController.h"

@implementation SettingsViewController {
     NSMutableArray *subjects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
}

-(void)viewWillAppear:(BOOL)animated
{
    subjects = [NSMutableArray arrayWithObjects:@"Show Video Controls",@"Allow Touch while Instructional Video is playing",@"Randomize Alternatives",@"Show Me How to get out of Play Mode", nil];
    
    [self.tableView setRowHeight:75];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //hide randomize option, as randomization is always needed
    if(indexPath.row==2){
        [[[Utility alloc] init] setUserSettings:YES keyName:[NSString stringWithFormat:@"Settings%d",200]];
        return 0;
    }
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //hide randomize option, as randomization is always needed
    if(indexPath.row==2)
        return cell;
    
    
    cell.textLabel.text = [subjects objectAtIndex:indexPath.row];
    
    UISwitch *switcher = [[UISwitch alloc] initWithFrame: CGRectMake(cell.bounds.size.width-80, cell.bounds.size.height/2-30, 75, 60)];
    switcher.tag = indexPath.row*100;
    [switcher addTarget: self action: @selector(flip:) forControlEvents: UIControlEventValueChanged];
    cell.accessoryView=switcher;
    
    switcher.on = [[[Utility alloc] init] getUserSettings:[NSString stringWithFormat:@"Settings%d",switcher.tag]];
    
    return cell;
}

- (IBAction)flip: (id)sender {
    UISwitch *onoff = (UISwitch *)sender;

    [[[Utility alloc] init] setUserSettings:onoff.on keyName:[NSString stringWithFormat:@"Settings%d",onoff.tag]];
}

@end
