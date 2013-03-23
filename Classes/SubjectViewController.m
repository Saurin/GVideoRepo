
#import "SubjectViewController.h"

@implementation SubjectViewController {
    NSMutableArray *imageFromArray;
    Subject *_dirtySubject;
    
    UIPopoverController *photoLibraryPopover;               //to pick image from photolibrary
    UIImagePickerController *imagePicker;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    imageFromArray = [NSMutableArray arrayWithObjects:@"Current Image",@"Camera",@"Photo Library", nil];

    //add right bar button to save subject and move to instructions
    UIBarButtonItem *saveSubject = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSubject:)];
    [saveSubject setTitle:@"Next"];
    [self.navigationItem setRightBarButtonItem:saveSubject];
    
    self.title = @"Subject";
    _dirtySubject=[self.thisSubject copy];
    
}

- (void)viewDidUnload {
	[super viewDidUnload];
    
    photoLibraryPopover=nil;
    self.tblImageFrom = nil;
    imageFromArray = nil;
}

-(void)viewDidLayoutSubviews {
    [self performSelector:@selector(sendSelectionNotification:) withObject:self.thisSubject afterDelay:0.1];
}
-(void)sendSelectionNotification:(id)object {
    [[ApplicationNotification notification] postNotificationFromSubjectView:object userInfo:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtSubject resignFirstResponder];
}

#pragma mark -
#pragma mark Rotation support

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
    return section==0?1:[imageFromArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    if(indexPath.section==0){
        
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        //add a textbox for subject description
        CGRect frame = cell.contentView.frame;
        frame.origin.x = 5;
        
        self.txtSubject = [[UITextField alloc] initWithFrame:frame];
        [self.txtSubject setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [cell.contentView addSubview:self.txtSubject];
        
        self.txtSubject.placeholder = @"A new Subject";
        if(self.thisSubject.subjectId!=-1){
            
            self.txtSubject.text = self.thisSubject.subjectName;
            //reset image object, if already created
            [self.imgCurrent removeFromSuperview];
            self.imgCurrent = nil;
            
            [self makeRoundRectView:self.btnDelete layerRadius:5];
        }
        //hide delete button while adding a new one
        else{
            [self.btnDelete setHidden:YES];
        }
    }
    else{

        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = [imageFromArray objectAtIndex:indexPath.row];
        
        //show current image, if any
        if(indexPath.row==0){
            cell.detailTextLabel.text = self.thisSubject.assetUrl;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            if(self.imgCurrent==Nil){

                [[Utility alloc] setImageFromAssetURL:self.thisSubject.assetUrl completion:^(NSString *url, UIImage *image) {
                    
                    self.imgCurrent = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width-80, cell.bounds.size.height/2-30, 75, 60)];
                    [self.imgCurrent setImage:image];
                    [self makeRoundRectView:self.imgCurrent layerRadius:10];
                    cell.accessoryView=self.imgCurrent;
                }];
            }
        }
    }

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return section==0?@"Subject Description":@"Image for Subject";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==1 && indexPath.row==0 ? 75 : 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1 && indexPath.row>0){
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self showImagePickerEasy:indexPath.row==1? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary selectedCell:cell];
    }
}

#pragma Save subject
-(IBAction)didSubjectDeleteClick:(id)sender {

    [[[OHAlertView alloc] initWithTitle:@""
                                message:@"Do you want to delete this Subject? You can't recover it once deleted."
                           cancelButton:@"Cancel"
                           otherButtons:[NSArray arrayWithObject:@"OK"]
                         onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                             if(buttonIndex==1){
                                 [[Data sharedData] deleteSubjectWithSubjectId:self.thisSubject.subjectId];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }
                         }] show];

}

-(IBAction)saveSubject:(id)sender
{
    //hide keyboard or dismiss popover
    [self.txtSubject resignFirstResponder];
    [photoLibraryPopover dismissPopoverAnimated:YES];
    
    [self save];
    
//    [[[OHAlertView alloc] initWithTitle:@""
//            message:@"Saved...This needs to go to next view"
//            cancelButton:nil
//            otherButtons:[NSArray arrayWithObject:@"OK"]
//            onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
//                [self.navigationController popViewControllerAnimated:YES];
//    }] show];
    
    QuizEditViewController *quizEditVC = [[QuizEditViewController alloc] initWithNibName:@"QuizEdit" bundle:nil];
    quizEditVC.subject = _dirtySubject;
    [self.navigationController pushViewController:quizEditVC animated:YES];
}

-(BOOL)didSubjectSelectionChange:(Subject *)newSubject {

    //hide keyboard or dismiss popover
    [self.txtSubject resignFirstResponder];
    [photoLibraryPopover dismissPopoverAnimated:YES];

    _dirtySubject.subjectName = self.txtSubject.text;
    if(![self.thisSubject isEqual:_dirtySubject]){
        
        [[[OHAlertView alloc] initWithTitle:@""
                message:@"Do you want to save the changes you made? Your changes will be lost if don't save them."
               cancelButton:@"No"
               otherButtons:[NSArray arrayWithObject:@"Yes"]
                 onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                     if(buttonIndex==1){
                         [self save];
                         [self.delegate didSubjectChange:_dirtySubject];
                         [self load:newSubject];
                     }
                     else{
                         [self load:newSubject];
                     }
             }] show];
    }
    //we have no changes detected, load new subject
    else{
        [self load:newSubject];
    }
    
    return YES;
}

-(BOOL)save{
    
    //do validation, or keep save button disabled
    _dirtySubject.subjectName = self.txtSubject.text;
    if(_dirtySubject.assetUrl==nil) _dirtySubject.assetUrl = @"";
    [[Data sharedData] saveSubject:_dirtySubject];

    return TRUE;
}

-(void)load:(Subject *)subject{
    
    self.thisSubject = subject;
    _dirtySubject=[self.thisSubject copy];
    
    [self.tblImageFrom reloadData];
    [self performSelector:@selector(sendSelectionNotification:) withObject:self.thisSubject afterDelay:0.1];
}

#pragma Camera and Photo library
- (void)showImagePickerEasy:(UIImagePickerControllerSourceType)sourceType selectedCell:(UITableViewCell *)cell {
    
    //if keyboard is visible, hide it
    [self.txtSubject resignFirstResponder];
    
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *assetURL = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] description];
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    // If there is no imageUrl, this was taken from the camera and needs to be saved.
    if (assetURL == nil)
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[pickedImage CGImage] orientation:(ALAssetOrientation)[pickedImage imageOrientation] completionBlock:^(NSURL *url, NSError   *error) {
            if (error) {
                NSLog(@"error");
            }
            else
            {
                _dirtySubject.assetUrl = url.absoluteString;
            }
        }];
    }
    else
    {
        _dirtySubject.assetUrl = assetURL;
    }

    //Now update current image with newly selected image
    UITableViewCell *cell = [self.tblImageFrom cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    cell.detailTextLabel.text = _dirtySubject.assetUrl;
    
    [[Utility alloc] setImageFromAssetURL:_dirtySubject.assetUrl completion:^(NSString *url, UIImage *image) {
        
        self.imgCurrent = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width-90, 7, 80, 60)];
        [self.imgCurrent setImage:image];
        [self makeRoundRectView:self.imgCurrent layerRadius:10];
        cell.accessoryView=self.imgCurrent;
    }];
    
    
    //close popover and picker
    [photoLibraryPopover dismissPopoverAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [photoLibraryPopover dismissPopoverAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}



@end
