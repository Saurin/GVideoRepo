#import "AlternativeViewController.h"
#import "AlternativeListViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation AlternativeViewController {

    NSMutableArray *imageFromArray, *videoFromArray, *responseFromArray;
    QuizOption *_dirtyOption;
    NSInteger userResponse;
    
    UIPopoverController *photoLibraryPopover;               //to pick image from photolibrary
    UIImagePickerController *videoPicker, *imagePicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageFromArray = [NSMutableArray arrayWithObjects:@"Current Image",@"Camera",@"Photo Library", nil];
    videoFromArray = [NSMutableArray arrayWithObjects:@"Current Video",@"Camera",@"Photo Library", nil];
    responseFromArray = [NSMutableArray arrayWithObjects:@"Repeat Instruction",@"Next Instruction", nil];
    
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
    
    _dirtyOption=[self.quizOption copy];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //add right bar button to save subject and move to instructions
    //only if VC is DetailViewController
    if(self.isDetailController){
        
        _dirtyOption= [self.quizOption copy];
        
        UIBarButtonItem *saveQuiz = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(didSaveClick:)];
        
        [saveQuiz setTintColor:[UIColor blueColor]];
        [self setOtherRightBarButtons:[NSArray arrayWithObject:saveQuiz]];
        
        //change it to AlternativeListViewController
        if(![self.detailViewManager.masterViewController isKindOfClass:[AlternativeListViewController class]]){
            AlternativeListViewController *masterController = [[AlternativeListViewController alloc] initWithNibName:@"AlternativeListView" bundle:nil];
            [masterController setQuizPage:[[Data sharedData] getQuizAtQuizId:self.quizOption.quizId]];
            [self.detailViewManager setMasterViewController:masterController];
        }
        
        if(self.quizOption.quizOptionId!=0)
            [self.btnDelete setHidden:NO];
        [self makeRoundRectView:self.btnDelete layerRadius:5];
    }
    else
    {
        [self.btnDelete setHidden:YES];
    }
    
    [self setTitle:self.quizOption.assetName];
    if(self.isDetailController){
        [self performSelector:@selector(sendSelectionNotification:) withObject:self.quizOption afterDelay:0.1];
    }

}

-(void)viewWillLayoutSubviews {
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    self.scrollView.frame=self.view.frame;
    if(orientation==UIDeviceOrientationFaceUp || UIDeviceOrientationIsLandscape(orientation)){
        self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width,750);
    }
    else{
        self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    }

    CGRect frame = self.btnDelete.frame;
    frame.origin.y=self.scrollView.contentSize.height-80;
    [self.btnDelete setFrame:frame];

}

- (void)viewDidUnload {
	[super viewDidUnload];
    
    photoLibraryPopover=nil;
    self.tblImageFrom = nil;
    videoFromArray = nil;
    imageFromArray=nil;
    responseFromArray=nil;
}

-(void)viewDidLayoutSubviews {
    
    if(self.isDetailController){
        [self performSelector:@selector(sendSelectionNotification:) withObject:self.quizOption afterDelay:0.1];
    }
}

-(void)sendSelectionNotification:(id)object {
    [[ApplicationNotification notification] postNotificationFromAlternativeView:object userInfo:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtOptionName resignFirstResponder];
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

#pragma Save Quiz
-(IBAction)didOptionDeleteClick:(id)sender {
    
    [[[OHAlertView alloc] initWithTitle:@""
                                message:@"Do you want to delete this Alternative? You can't recover it once deleted."
                           cancelButton:@"Cancel"
                           otherButtons:[NSArray arrayWithObject:@"OK"]
                         onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                             if(buttonIndex==1){
                                 [[Data sharedData] deleteQuizOptionWithId:self.quizOption.quizOptionId];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }
                         }] show];
}

-(IBAction)didSaveClick:(id)sender
{
    //hide keyboard or dismiss popover
    [self.txtOptionName resignFirstResponder];
    [photoLibraryPopover dismissPopoverAnimated:YES];
    videoPicker=nil;
    imagePicker=nil;
    responseFromArray=nil;
    
    if([self save]){
        
         [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)didQuizSelectionChange:(QuizPage *)newQuiz {
    
    //hide keyboard or dismiss popover
//    [self.txtOptionName resignFirstResponder];
//    [photoLibraryPopover dismissPopoverAnimated:YES];
//    
//    _dirtyQuiz.quizName = self.txtQuizName.text;
//    if(![self.thisQuiz isEqual:_dirtyQuiz]){
//        
//        [[[OHAlertView alloc] initWithTitle:@""
//                                    message:@"Do you want to save the changes you made? Your changes will be lost if don't save them."
//                               cancelButton:@"No"
//                               otherButtons:[NSArray arrayWithObject:@"Yes"]
//                             onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
//                                 if(buttonIndex==1){
//                                     [self save];
//                                     [self.delegate didQuizChange:_dirtyQuiz];
//                                     [self load:newQuiz];
//                                 }
//                                 else{
//                                     [self load:newQuiz];
//                                 }
//                             }] show];
//    }
//    //we have no changes detected, load new subject
//    else{
//        [self load:newQuiz];
//    }
//    
    return YES;
}

-(BOOL)save{
    
    //do validation, or keep save button disabled
    _dirtyOption.assetName = [self.txtOptionName.text isEqualToString:@""]?self.txtOptionName.placeholder:self.txtOptionName.text;
    if(_dirtyOption.videoUrl==nil) _dirtyOption.videoUrl = @"";
    if(_dirtyOption.assetUrl==nil) _dirtyOption.assetUrl=@"";
    if(userResponse==0)
        userResponse=3;         //repeat quiz
    else if(userResponse==1)
        userResponse=4;         //goto next quiz;
    
    _dirtyOption.response=userResponse;
    
    NSInteger res = [[Data sharedData] saveQuizOption:_dirtyOption];
    _dirtyOption.quizOptionId=res;
    self.quizOption = [_dirtyOption copy];
    
    return TRUE;
}

-(void)load:(QuizOption *)option{
    
    self.quizOption = option;
    _dirtyOption=[self.quizOption copy];
    
    [self.tblImageFrom reloadData];
    [self performSelector:@selector(sendSelectionNotification:) withObject:self.quizOption afterDelay:0.1];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    else if(section==1){                        //allow user to pick image
        if(self.isDetailController)
            return [imageFromArray count];
        else
            return 1;
    }
    else if(section==2){                        //allow user to pick response video
        if(self.isDetailController)
            return [videoFromArray count];
        else
            return 1;
    }
    else {                                      //allow user to provide what action app needs to take on
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){

        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        //add a textbox for alternate description
        CGRect frame = cell.contentView.frame;
        frame.origin.x = 5;
        
        self.txtOptionName = [[UITextField alloc] initWithFrame:frame];
        self.txtOptionName.placeholder = @"Add a new alternative";
        [self.txtOptionName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [cell.contentView addSubview:self.txtOptionName];
        
        if(!self.isDetailController){
            [self.txtOptionName setUserInteractionEnabled:NO];
        }
        if(self.quizOption.quizOptionId!=0){
            
            self.txtOptionName.text = self.quizOption.assetName;
            [self.imgCurrent removeFromSuperview];
            [self.imgVideoCurrent removeFromSuperview];
            self.imgCurrent = nil;
            self.imgVideoCurrent=nil;
            userResponse=self.quizOption.response;
            
            [self makeRoundRectView:self.btnDelete layerRadius:5];
        }
        //hide delete button while adding a new one
        else{
            [self.btnDelete setHidden:YES];
        }
        
        return cell;
    }
    
    else if(indexPath.section==1){
        
        //dont want to reuse cell as we have cell image getting added on a different queue
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = [imageFromArray objectAtIndex:indexPath.row];
  
        //show current image, if any
        if(indexPath.row==0){
            cell.detailTextLabel.text = self.quizOption.assetUrl;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            if(self.imgCurrent==Nil){
                
                [[Utility alloc] getImageFromAssetURL:self.quizOption.assetUrl completion:^(NSString *url, UIImage *image) {
                    
                    self.imgCurrent = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width-80, cell.bounds.size.height/2-30, 75, 60)];
                    [self.imgCurrent setImage:image];
                    [self makeRoundRectView:self.imgCurrent layerRadius:10];
                    cell.accessoryView=self.imgCurrent;
                }];
            }
        }

        return cell;
    }
    else if(indexPath.section==2){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

        if(!self.isDetailController)
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = [videoFromArray objectAtIndex:indexPath.row];
        
        //show current video, if any
        if(indexPath.row==0){
            cell.detailTextLabel.text = self.quizOption.videoUrl;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            if(self.imgVideoCurrent==Nil){
                
                [[Utility alloc] getThumbnailFromVideoURL:self.quizOption.videoUrl completion:^(NSString *url, UIImage *image) {
                    
                    self.imgVideoCurrent = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width-80, cell.bounds.size.height/2-30, 75, 60)];
                    [self.imgVideoCurrent setImage:image];
                    [self makeRoundRectView:self.imgVideoCurrent layerRadius:10];
                    cell.accessoryView=self.imgVideoCurrent;
                }];
            }
        }
        
        return cell;
    }
    
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        cell.textLabel.text = [responseFromArray objectAtIndex:indexPath.row];
        
        if(userResponse==3)
            userResponse=0;         //repeat quiz
        else if(userResponse==4)
            userResponse=1;         //next quiz
        if(userResponse==indexPath.row)
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        return  cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Alternative Description";
            break;
   
        case 1:
            return @"Image for Alternative";
            break;
            
        case 2:
            return @"Video for Alternative";
            break;
            
        default:
            return @"Response";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section==1 || indexPath.section==2) && indexPath.row==0 ? 75 : 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section==1 && indexPath.row>0){
        
        [self showImagePickerEasy:indexPath.row==1? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary selectedCell:cell];
    }

    else if(indexPath.section==2 && indexPath.row>0){

        [self showVideoPicker:indexPath.row==1? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary selectedCell:cell];
    }
    else if(indexPath.section==3){
        userResponse=indexPath.row;
        for (NSInteger j=0; j<responseFromArray.count ; j++) {
            [[self.tblImageFrom cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:3]] setAccessoryType:UITableViewCellAccessoryNone];
        }
        [[self.tblImageFrom cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

#pragma Camera and Photo library
- (void)showImagePickerEasy:(UIImagePickerControllerSourceType)sourceType selectedCell:(UITableViewCell *)cell {
    
    //if keyboard is visible, hide it
    [self.txtOptionName resignFirstResponder];
    
    if(imagePicker==nil){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
    }
    
    imagePicker.sourceType=sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [self presentViewController:imagePicker animated:YES completion:^{
        }];
    }
    else
    {
        if(photoLibraryPopover==nil){
            photoLibraryPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            photoLibraryPopover.delegate=self;
        }
        [photoLibraryPopover presentPopoverFromRect:cell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

-(void)showVideoPicker:(UIImagePickerControllerSourceType)sourceType selectedCell:(UITableViewCell *)cell{
    
    //if keyboard is visible, hide it
    [self.txtOptionName resignFirstResponder];
    
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [[info objectForKey:@"UIImagePickerControllerMediaType"] description];
    
    if([mediaType isEqualToString:@"public.image"]){           //image picking done here......

        NSString *assetURL = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] description];
        UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // If there is no imageUrl, this was taken from the camera and needs to be saved.
        if (assetURL == nil)
        {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:[pickedImage CGImage] orientation:(ALAssetOrientation)[pickedImage imageOrientation] completionBlock:^(NSURL *url, NSError   *error) {
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:@"" message:@"Unable to save Image" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                }
                else
                {
                    _dirtyOption.assetUrl = url.absoluteString;
                    [self showSelectedImageWithURL:url.absoluteString];
                }
            }];
            [picker dismissViewControllerAnimated:YES completion:^{
            }];
        }
        else
        {
            _dirtyOption.assetUrl = assetURL;
            [self showSelectedImageWithURL:assetURL];
            
            //close popover and picker
            [photoLibraryPopover dismissPopoverAnimated:YES];
            [picker dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }
    else {
        NSString *assetURL = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] description];
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        if(assetURL==nil){
            //you taking new one
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
            }
        }
        
        
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        _dirtyOption.videoUrl = videoUrl.absoluteString;
        
        [[Utility alloc] getThumbnailFromVideoURL:videoUrl.absoluteString completion:^(NSString *url, UIImage *image) {
            [self.imgVideoCurrent setImage:image];
        }];
        
        [photoLibraryPopover dismissPopoverAnimated:YES];
        
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
        videoPicker=nil;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [photoLibraryPopover dismissPopoverAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
    imagePicker=nil;
    videoPicker=nil;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    photoLibraryPopover=nil;
    imagePicker=nil;
    videoPicker=nil;
}

-(void)showSelectedImageWithURL:(NSString *)assetUrl {
    
    //Now update current image with newly selected image
    UITableViewCell *cell = [self.tblImageFrom cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    cell.detailTextLabel.text = assetUrl;
    
    [[Utility alloc] getImageFromAssetURL:assetUrl completion:^(NSString *url, UIImage *image) {
        
        self.imgCurrent = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width-90, 7, 80, 60)];
        [self.imgCurrent setImage:image];
        [self makeRoundRectView:self.imgCurrent layerRadius:10];
        cell.accessoryView=self.imgCurrent;
    }];
}

@end
