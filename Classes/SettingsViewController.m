

#import "SettingsViewController.h"

@implementation SettingsViewController {
     NSMutableArray *options;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
}

-(void)viewWillAppear:(BOOL)animated
{
    options = [NSMutableArray arrayWithObjects:
               [NSMutableArray arrayWithObjects:@"Show Video Controls",[NSString stringWithFormat:@"%d",kShowVideoControls], nil],
               [NSMutableArray arrayWithObjects:@"Allow Touch while Instructional Video is playing",[NSString stringWithFormat:@"%d",kAllowTouchWhileVideoPlaying], nil],
               [NSMutableArray arrayWithObjects:@"Show Me How to get out of Play Mode",[NSString stringWithFormat:@"%d",kShowPlayModeMessage], nil],
               [NSMutableArray arrayWithObjects:@"Show Tutorial",[NSString stringWithFormat:@"%d",kShowTutorial], nil],
               nil];
    
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
    return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSMutableArray *array = [options objectAtIndex:indexPath.row];
    cell.textLabel.text = [array objectAtIndex:0];
    
    UISwitch *switcher = [[UISwitch alloc] initWithFrame: CGRectMake(cell.bounds.size.width-80, cell.bounds.size.height/2-30, 75, 60)];
    NSLog(@"%d",[[array objectAtIndex:1] intValue]);
    switcher.tag = [[array objectAtIndex:1] intValue];
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
