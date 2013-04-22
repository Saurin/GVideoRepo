
#import "InstructionViewController.h"
#import "InstructionListViewController.h"
#import "AlternativeListViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>  
#import "PreviewViewController.h"

@implementation InstructionViewController {
    NSMutableArray *videoFromArray;
    QuizPage *_dirtyQuiz;
    
    UIPopoverController *photoLibraryPopover;               //to pick image from photolibrary
    UIImagePickerController *videoPicker;
    MPMoviePlayerController *moviePlayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    videoFromArray = [NSMutableArray arrayWithObjects:@"Current Video",@"Camera",@"Photo Library", nil];
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
    
    self.title = @"Instruction";
    _dirtyQuiz=[self.thisQuiz copy];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //add right bar button to save subject and move to instructions
    //only if VC is DetailViewController
    if(self.isDetailController){
        
        _dirtyQuiz= [self.thisQuiz copy];
        
        UIBarButtonItem *saveQuiz = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(didSaveQuizAndNextClick:)];
        
        [saveQuiz setTintColor:[UIColor blueColor]];
        [self setOtherRightBarButtons:[NSArray arrayWithObject:saveQuiz]];
        
        //if masterviewcontroller is not InsturctionListViewController, change it to InsturctionListViewController
        if(![self.detailViewManager.masterViewController isKindOfClass:[InstructionListViewController class]]){
            InstructionListViewController *masterController = [[InstructionListViewController alloc] initWithNibName:@"InstructionListView" bundle:nil];
            [masterController setThisSubject:[[Data sharedData] getSubjectAtSubjectId:self.thisQuiz.subjectId]];
            [self.detailViewManager setMasterViewController:masterController];
        }
        if(self.thisQuiz.quizId!=0)
            [self.btnDelete setHidden:NO];
        [self makeRoundRectView:self.btnDelete layerRadius:5];
    }
    else{
        [self.btnDelete setHidden:YES];
    }
    
    [self setTitle:self.thisQuiz.quizName];
    if(self.isDetailController){
        [self performSelector:@selector(sendSelectionNotification:) withObject:self.thisQuiz afterDelay:0.1];
    }

}

- (void)viewDidUnload {
	[super viewDidUnload];
    
    photoLibraryPopover=nil;
    self.tblVideoFrom = nil;
    videoFromArray = nil;
}

-(void)sendSelectionNotification:(id)object {
    [[ApplicationNotification notification] postNotificationFromInstructionView:object userInfo:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtQuizName resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Rotation support

-(BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    else{
        if(self.isDetailController)
            return [videoFromArray count];
        else
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    if(indexPath.section==0){
        
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        //add a textbox for subject description
        CGRect frame = cell.contentView.frame;
        frame.origin.x = 5;
        frame.size.width-=5;
        
        self.txtQuizName = [[UITextField alloc] initWithFrame:frame];
        [self.txtQuizName setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ];

        self.txtQuizName.placeholder = @"A new Instructional Video";
        [self.txtQuizName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [cell.contentView addSubview:self.txtQuizName];
        
        if(!self.isDetailController){
            [self.txtQuizName setUserInteractionEnabled:NO];
        }
        if(self.thisQuiz.quizId!=0){
            
            self.txtQuizName.text = self.thisQuiz.quizName;
            //reset image object, if already created
            [self.imgCurrentVideo removeFromSuperview];
            self.imgCurrentVideo = nil;
            
            [self makeRoundRectView:self.btnDelete layerRadius:5];
        }
        //hide delete button while adding a new one
        else{
            [self.btnDelete setHidden:YES];
        }
    }
    else{
        
        if(!self.isDetailController)
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = [videoFromArray objectAtIndex:indexPath.row];
        
        //show current image, if any
        if(indexPath.row==0){
            cell.detailTextLabel.text = self.thisQuiz.videoUrl;
            [cell setAccessoryType:UITableViewCellAccessoryNone];

            if(self.imgCurrentVideo==Nil){
            
                [[Utility alloc] getThumbnailFromVideoURL:self.thisQuiz.videoUrl completion:^(NSString *url, UIImage *image) {
                    
                    self.imgCurrentVideo = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width-80, cell.bounds.size.height/2-30, 75, 60)];
                    [self.imgCurrentVideo setImage:image];
                    [self makeRoundRectView:self.imgCurrentVideo layerRadius:10];
                    cell.accessoryView=self.imgCurrentVideo;
                }];
            }
        }
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return section==0?@"Instruction Description":@"Video for Instruction";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==1 && indexPath.row==0 ? 75 : 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section==1 && indexPath.row>0){
        [self showVideoPicker:indexPath.row==1? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary selectedCell:cell];
    }
    else if(indexPath.section==1 && indexPath.row==0 && ![self.thisQuiz.videoUrl isEqualToString:@""]) {
        [self performSelector:@selector(showVideoAtCell:) withObject:cell afterDelay:0.2];
    }
}

#pragma Save Quiz
-(IBAction)didQuizDeleteClick:(id)sender {
    
    [[[OHAlertView alloc] initWithTitle:@""
                                message:@"Do you want to delete this Instruction? You can't recover it once deleted."
                           cancelButton:@"Cancel"
                           otherButtons:[NSArray arrayWithObject:@"OK"]
                         onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                             if(buttonIndex==1){
                                 [[Data sharedData] deleteQuizWithQuizId:self.thisQuiz.quizId];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }
                         }] show];
    
}

-(IBAction)didSaveQuizAndNextClick:(id)sender
{
    //hide keyboard or dismiss popover
    [self.txtQuizName resignFirstResponder];
    [photoLibraryPopover dismissPopoverAnimated:YES];
    videoPicker=nil;
    
    if([self save]){
        
        //Now change MasterViewController to show readonly suject
        InstructionViewController *masterViewController = [[InstructionViewController alloc] initWithNibName:@"InstructionView" bundle:nil];
        [masterViewController setIsDetailController:NO];
        [masterViewController setThisQuiz:_dirtyQuiz];
        [self.detailViewManager setMasterViewController:masterViewController];
        
        //push it to Alternative List as DetailViewController
        AlternativeListViewController *detailViewController = [[AlternativeListViewController alloc] initWithNibName:@"AlternativeListView" bundle:nil];
        [detailViewController setQuizPage:_dirtyQuiz];
        [detailViewController setIsListDetailController:YES];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }

}

-(BOOL)didQuizSelectionChange:(QuizPage *)newQuiz {
    
    //hide keyboard or dismiss popover
    [self.txtQuizName resignFirstResponder];
    [photoLibraryPopover dismissPopoverAnimated:YES];

    _dirtyQuiz.quizName = self.txtQuizName.text;
    if(![self.thisQuiz isEqual:_dirtyQuiz]){

        [[[OHAlertView alloc] initWithTitle:@""
                                    message:@"Do you want to save the changes you made? Your changes will be lost if don't save them."
                               cancelButton:@"No"
                               otherButtons:[NSArray arrayWithObject:@"Yes"]
                             onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                                 if(buttonIndex==1){
                                     [self save];
                                     [self.delegate didQuizChange:_dirtyQuiz];
                                     [self load:newQuiz];
                                 }
                                 else{
                                     [self load:newQuiz];
                                 }
                             }] show];
    }
    //we have no changes detected, load new subject
    else{
        [self load:newQuiz];
    }
    
    return YES;
}

-(BOOL)save{
    
    //do validation, or keep save button disabled
    _dirtyQuiz.quizName = [self.txtQuizName.text isEqualToString:@""]?self.txtQuizName.placeholder:self.txtQuizName.text;
    if(_dirtyQuiz.videoUrl==nil) _dirtyQuiz.videoUrl = @"";
    
    NSInteger res = [[Data sharedData] saveQuiz:_dirtyQuiz];
    _dirtyQuiz.quizId=res;
    self.thisQuiz = [_dirtyQuiz copy];
    
    //user might have changed name...
    [self setTitle:self.thisQuiz.quizName];
    
    return TRUE;
}

-(void)load:(QuizPage *)quiz{
    
    self.thisQuiz = quiz;
    _dirtyQuiz=[self.thisQuiz copy];
    
    [self.tblVideoFrom reloadData];
    [self performSelector:@selector(sendSelectionNotification:) withObject:self.thisQuiz afterDelay:0.1];
}

-(void)showVideoAtCell:(UITableViewCell *)cell {
    
    NSURL *url = [NSURL URLWithString:self.thisQuiz.videoUrl];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [player prepareToPlay];
    
    [player.view setFrame:CGRectMake(0, 0, 450, 300)];
    [player.view setAlpha:1];
    [self.view addSubview:player.view];
    
    player.controlStyle=MPMovieControlStyleEmbedded;
    player.movieSourceType=MPMovieSourceTypeStreaming;
    player.shouldAutoplay=NO;
    player.scalingMode=MPMovieScalingModeAspectFill & MPMovieScalingModeAspectFit;
    moviePlayer=player;
    
}


#pragma Camera and Photo library
-(void)showVideoPicker:(UIImagePickerControllerSourceType)sourceType selectedCell:(UITableViewCell *)cell{
    
    //if keyboard is visible, hide it
    [self.txtQuizName resignFirstResponder];
    
    if(videoPicker==nil){
        videoPicker = [[UIImagePickerController alloc] init];
        videoPicker.delegate = self;
        videoPicker.sourceType = sourceType;
    }
    videoPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [self presentViewController:videoPicker animated:YES completion:^{
        }];
    }
    else
    {
        photoLibraryPopover = [[UIPopoverController alloc] initWithContentViewController:videoPicker];
        photoLibraryPopover.delegate=self;
        [photoLibraryPopover presentPopoverFromRect:cell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *assetURL = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] description];
    NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
    
    if(assetURL==nil){
        //you taking new one
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        }
    }
    

    NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
    _dirtyQuiz.videoUrl = videoUrl.absoluteString;
    
    [[Utility alloc] getThumbnailFromVideoURL:videoUrl.absoluteString completion:^(NSString *url, UIImage *image) {
        [self.imgCurrentVideo setImage:image];
    }];

    [photoLibraryPopover dismissPopoverAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    videoPicker=nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [photoLibraryPopover dismissPopoverAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    videoPicker=nil;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    photoLibraryPopover=nil;
    videoPicker=nil;
}

@end
