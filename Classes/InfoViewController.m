

#import "InfoViewController.h"
#import "NSString+HexColor.h"

@implementation InfoViewController {
    Help *help;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.view addSubview:toolbar];
    UIColor *color = [@"#32445E" getHexColor];
    [[UIToolbar appearance] setTintColor:color];

    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didDoneClick:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items=[NSArray arrayWithObjects:space,done, nil];
    
    @try {
        NSMutableArray *helpArray = ((AppDelegate *)[UIApplication sharedApplication].delegate).helpArray;
        help=(Help *)[[helpArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name=%@",self.sender]] objectAtIndex:0];
    }
    @catch (NSException *exception) {
        help = [[Help alloc] initWithName:@"" purpose:@"" section:@"" action:@"" exit:@"" nomenclature:@""];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [help.getHelpTopic count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

    if(indexPath.row+1>help.getHelpTopic.count){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tutorial.png"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        imageView.frame=CGRectMake(0,0, 900, 1814);
        
        [cell.contentView addSubview:imageView];
        return cell;
    }

    
    cell.textLabel.text = [help.getHelpTitle objectAtIndex:indexPath.row];
    if([cell.textLabel.text isEqualToString:@"NomenclatureImage"]){
        cell.textLabel.text=@"";
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 366, 291)];
        imgView.image = [UIImage imageNamed:@"GuidedVideoInstructions.png"];
        [cell.contentView addSubview:imgView];
    }
    else{

        cell.detailTextLabel.numberOfLines=0;
        cell.detailTextLabel.text = [help.getHelpTopic objectAtIndex:indexPath.row];

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *cellFont = [UIFont systemFontOfSize:15];
    CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);

    
    if(indexPath.row+1>help.getHelpTopic.count)
        return 1814;
    
    NSString *cellText = [help.getHelpTitle objectAtIndex:indexPath.row];
    if([cellText isEqualToString:@"NomenclatureImage"]){
        return 330;
    }

    
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    cellText = [help.getHelpTopic objectAtIndex:indexPath.row];
    constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize labelDetailSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    NSInteger height = labelSize.height+labelDetailSize.height;
    height+=height>70?70:30;
    
    return height;
}

@end
