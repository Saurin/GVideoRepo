
#import "MenuTableViewController.h"
#import "DetailViewManager.h"
#import "DetailViewController.h"
#import "SettingsViewController.h"
#import "SubjectListViewController.h"
#import "PlayViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "WebViewController.h"
#import "MBProgressHUD.h"

@implementation MenuTableViewController {
    NSMutableArray *options;
    BaseViewController <SubstitutableDetailViewController> *detailViewController;
    
    MBProgressHUD *HUD;
}


-(void)viewDidLoad
{
    options = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"Configure",@"Play",nil]
               ,[NSMutableArray arrayWithObjects:@"Settings",@"Review",nil]
               ,[NSMutableArray arrayWithObjects:@"Contact",@"About",nil]
               , nil];
    
    
    self.title = @"Guided Video";
    self.clearsSelectionOnViewWillAppear = NO;
}

#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    return YES;
}

-(BOOL)shouldAutorotate {
    [super shouldAutorotate];
    return  YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [options count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSMutableArray *)[options objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    // Set appropriate labels for the cells.
    cell.textLabel.text = [(NSMutableArray *)[options objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark -
#pragma mark Table view selection

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get a reference to the DetailViewManager.
    // DetailViewManager is the delegate of our split view.
    
    // DetailViewManager exposes a property, detailViewController.  Set this property
    // to the detail view controller we want displayed.  Configuring the detail view
    // controller to display the navigation button (if needed) and presenting it
    // happens inside DetailViewManager.

    DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
    // Create and configure a new detail view controller appropriate for the selection.
    detailViewController = nil;
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    if(section==0){
        switch (row) {
            case 0:{

                SubjectListViewController *newDetailViewController = [[SubjectListViewController alloc] initWithNibName:@"SubjectListView" bundle:nil];
                [newDetailViewController setIsListDetailController:YES];
                detailViewController = newDetailViewController;

                break;
            }
            case 1:{
                
                if([[[Utility alloc] init] getUserSettings:@"Configure"]==0){
                
                    [OHAlertView showAlertWithTitle:@"" message:@"Shake your device to come out of Play mode. You should turn on Guided Access, if not yet. Do you want continue and quit edit mode?" cancelButton:@"Don't Show me again" otherButtons:[NSArray arrayWithObjects:@"OK",@"Cancel", nil] onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                        switch (buttonIndex) {
                           
                            case 0:
                                [[[Utility alloc] init] setUserSettings:1 keyName:@"Configure"];
                                [self.navigationController presentModalViewController:[[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil] animated:YES];

                                break;
                            
                            case 1:{

                                [self.navigationController presentModalViewController:[[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil] animated:YES];
                                
                                break;
                            }
                            default:
                                break;
                        }
                    }];
                }
                else{

                    PlayViewController *playVC = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
                    [self.navigationController presentModalViewController:playVC animated:YES];

                }
                
                return nil;
                break;
            }
            default:
                break;
        }
    }
    else if (section==1){
        switch (row) {
            case 0:
                
                detailViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
                break;
                
            default:{
                
                DetailViewController *newDetailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
                newDetailViewController.sender = @"Review";
                detailViewController = newDetailViewController;
                break;
            }
        }
    }
    else if(section==2){
        
        switch (row) {
            case 0:{
                
                [self contactUs];
                return nil;
                break;
            }
            default:{

                DetailViewController *newDetailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
                newDetailViewController.sender = @"About";
                detailViewController = newDetailViewController;
                break;
            }
        }
    }
    
    detailViewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    detailViewManager.detailViewController = detailViewController;
    
    return indexPath;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
       && section==[options count]-1){
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GuidedVideo.png"]];
        [imageView setContentMode:UIViewContentModeCenter];
        [self makeRoundRectView:imageView];
        imageView.frame=CGRectMake((self.view.bounds.size.width-imageView.frame.size.width)/2, 30, imageView.frame.size.width, imageView.frame.size.height);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        [view addSubview:imageView];
        
        //Now load default detail view, if not loaded
        if(detailViewController==nil){
            [self performSelector:@selector(loadDefaultDetailViewController) withObject:nil afterDelay:0.2];
        }
        return view;
    }
    
    return [[UIView alloc] init];
}

-(void)loadDefaultDetailViewController {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationTop];
    [self tableView:self.tableView willSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

-(void)makeRoundRectView:(UIView *)view {
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;
}

-(void)contactUs {
    
    if(![MFMailComposeViewController canSendMail]){
        [[[UIAlertView alloc] initWithTitle:@"" message:@"This device is not configured for email. To contact the Guided Video LLC, go to  www.GuidedVideo.com." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        
        return;
    }
    
    MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
    emailer.mailComposeDelegate = self;
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"guidedvideo@guidedvideo.com"];
    NSString *mailerTitle = @"Contact Us";
    
    NSString *emailBody = nil;
    NSString *AppSite = @"United States";
    
    emailBody = [NSString stringWithFormat:@"\n\n\nDevice: %@ (%@)\n OS: %@ \n App Version: %@ \n GuidedVideo Site: %@", [Utility device], [Utility deviceModel], [Utility deviceOS], [Utility appVersion], AppSite];
    
    mailerTitle = [NSString stringWithFormat:@"%@ %@", mailerTitle, [Utility appVersion]];
    
    [emailer setSubject:@"GuidedVideo"];
    [emailer setToRecipients:toRecipients];
    [emailer setTitle:mailerTitle];
    [emailer setMessageBody:emailBody isHTML:NO];
    
    [[emailer navigationBar] setTintColor:[UIColor blackColor]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        emailer.modalPresentationStyle = UIModalPresentationPageSheet;
    }
    [self presentModalViewController:emailer animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissModalViewControllerAnimated:YES];
    
    if (result == MFMailComposeResultFailed) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Failed to send email" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
    else if(result==MFMailComposeResultSent){
        //show thanks message here....
        //[[[UIAlertView alloc] initWithTitle:@"" message:@"Thank You. \nWe have received your information." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

@end
