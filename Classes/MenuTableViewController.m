
#import "MenuTableViewController.h"
#import "DetailViewManager.h"
#import "DetailViewController.h"
#import "SettingsViewController.h"
#import "SubjectListViewController.h"
#import "ContentListViewController.h"
#import "PlayViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "WebViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@implementation MenuTableViewController {
    NSMutableArray *options;
    BaseViewController <SubstitutableDetailViewController> *detailViewController;
    
    MBProgressHUD *HUD;
    BOOL showOverlay;
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

                PlayViewController *play = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
                
                //show message, if needed
                BOOL show  = [[[Utility alloc] init] userSettingsExists:[NSString stringWithFormat:@"Settings%d",kShowPlayModeMessage]];
                //if key doesn't exists, force show
                if(!show){
                    [[[Utility alloc] init] setUserSettings:YES keyName:[NSString stringWithFormat:@"Settings%d",kShowPlayModeMessage]];
                    show=YES;
                }
                else{
                    show  = [[[Utility alloc] init] getUserSettings:[NSString stringWithFormat:@"Settings%d",kShowPlayModeMessage]];
                }
                if(show){
                
                    [OHAlertView showAlertWithTitle:@"" message:@"Remember to firmly shake device to exit Play Mode and return to this view" cancelButton:@"Don't Show again" otherButtons:[NSArray arrayWithObjects:@"OK",@"Cancel", nil] onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                        
                        if (buttonIndex==0) {
                            [[[Utility alloc] init] setUserSettings:NO keyName:[NSString stringWithFormat:@"Settings%d",kShowPlayModeMessage]];
                            [self.navigationController presentViewController:play animated:YES completion:^{}];
                        }
                        else if(buttonIndex==1){
                            [self.navigationController presentViewController:play animated:YES completion:^{}];
                        }
                    }];
                }
                else{
                    [self.navigationController presentViewController:play animated:YES completion:^{}];
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
            
            case 1: {
                
                DetailViewController *newDetailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
                newDetailViewController.sender = @"Review";
                detailViewController = newDetailViewController;
                break;
            }
            
            default:{

                detailViewController = [[ContentListViewController alloc] initWithNibName:@"ContentListView" bundle:nil];
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
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guidedvideo_watermark.png"]];
        [imageView setContentMode:UIViewContentModeCenter];
        [self makeRoundRectView:imageView];
        imageView.frame=CGRectMake((self.view.bounds.size.width-imageView.frame.size.width)/2, 30, imageView.frame.size.width, imageView.frame.size.height);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        [view addSubview:imageView];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height+30, self.view.bounds.size.width, 40)];
        lbl.text = @"www.guidedvideo.com";
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:lbl];
        
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
    [self presentViewController:emailer animated:YES completion:^{
    }];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissViewControllerAnimated:YES completion:^{
    }];
    
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
