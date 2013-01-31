//
//  EditViewController.m
//  GuidedVideo
//
//  Created by Mark Wade on 12/9/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import "EditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "OHActionSheet.h"
#import "OHAlertView.h"
#import "SubjectMenuCell.h"


@interface EditViewController ()

@end


@implementation EditViewController

NSString *kCellID = @"SubjectCellID";

@synthesize delegate = _delegate;
@synthesize selectedImage;
@synthesize imagePicker;
@synthesize selectedSubjectIndex;
@synthesize selectedSubject;
@synthesize subjectButtons;
@synthesize photoLibraryPopover = _photoLibraryPopover;
@synthesize subjectMenuContent = _subjectMenuContent;
@synthesize subjectMenuPopover = _subjectMenuPopover;

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
    
//    self.overlayViewController =
//    [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    
//    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
//    self.overlayViewController.delegate = self;
    self.contentSizeForViewInPopover = CGSizeMake(150.0, 140.0);
    
    self.subjectButtons = [[NSMutableArray alloc] init];
    
//    Subject *mySubject = [[Subject alloc] init];
//    mySubject.subjectName = @"Spelling";
//    
//    [self.subjectButtons addObject:mySubject];
//    
//    Subject *mathSubject = [[Subject alloc] init];
//    mathSubject.subjectName = @"Math";
//    mathSubject.assetUrl = @"Test URL";
//    
//    [self.subjectButtons addObject:mathSubject];
//    

    
    [self displayContent];
    
    Subject *addButton = [[Subject alloc] init];
    addButton.isAddButton = YES;
    
    [self.subjectButtons addObject:addButton];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else {
        return NO;
    }
}

- (IBAction)didClickDoneButton:(id)sender {
    NSLog(@"delegate: %@", self.delegate);
    
    // Serialize the objects into JSON
    //self.subjectButtons
    
    //convert object to data
    NSError *error;

    NSDictionary *dict;
    NSMutableArray *myMutableArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.subjectButtons count]; i++) {
        Subject *subject = [self.subjectButtons objectAtIndex:i];
        if (!subject.isAddButton) {
            dict = [self dictionaryFromSubject:subject];
            NSLog(@"URL: %@", subject.assetUrl);
            NSLog(@"dict: %@", dict);
            [myMutableArray addObject:dict];
        }
    }

    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:myMutableArray
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *content = [[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String: %@", content);

    [self writeToTextFileWithContent:content];
        
    if ([self.delegate respondsToSelector:@selector(didUpdatePresentation)]) {
        [self.delegate didUpdatePresentation];
        
    }
}

- (NSDictionary *)dictionaryFromSubject:(Subject*)subject {
    if ([subject.subjectName length]==0) {
        subject.subjectName = @"";
    }
    NSLog(@"Making a Dictionary out of :%@ and %@", subject.subjectName, subject.assetUrl);
    return [NSDictionary dictionaryWithObjectsAndKeys:subject.subjectName,@"subjectName",
            subject.assetUrl, @"assetUrl",
            nil];
}

//Method writes a string to a text file
- (void) writeToTextFileWithContent:(NSString *)content{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/GuidedVideo.json",
                          documentsDirectory];
    //save content to the documents directory
    [content writeToFile:fileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    
}


//Method retrieves content from documents directory
- (void) displayContent{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/GuidedVideo.json",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    
    if (data != nil) {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
        self.subjectButtons = [[NSMutableArray alloc] init];
    
        if (!jsonArray) {
            NSLog(@"Error parsing JSON: %@", e);
        } else {
            for(NSDictionary *item in jsonArray) {
                Subject *savedSubject = [[Subject alloc] init];
                savedSubject.subjectName = [item objectForKey:@"subjectName"];
                savedSubject.assetUrl = [item objectForKey:@"assetUrl"];
                savedSubject.isAddButton = NO;
                [self.subjectButtons addObject:savedSubject];
            
            }

            [self.subjectCollectionView reloadData];

        }
    }
}

- (IBAction)didClickAddMenu:(id)sender {
    
    if (_subjectMenuContent == nil) {
        self.subjectMenuContent = [[SubjectMenuViewController alloc] init];
 //       _colorPicker.delegate = self;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self.subjectMenuContent = [storyboard instantiateViewControllerWithIdentifier:@"subjectMenuPopupID"];
        
        if (self.subjectMenuPopover == nil) {
            self.subjectMenuPopover = [[UIPopoverController alloc]
                                   initWithContentViewController:_subjectMenuContent];
        }

        [self.subjectMenuPopover presentPopoverFromBarButtonItem:sender
                                    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}


- (void)didClickAddTopicButton:(id)sender {
    UIButton *clickedButton = (UIButton *)sender;
    
    NSLog(@"Clicked Add Button: %d", clickedButton.tag);
}

- (void)showTopicButtonEditActionSheet:(UITapGestureRecognizer *)recognizer {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Add Quiz", @"Take Photo", @"Choose Existing Photo", @"Enter Text", @"Delete", nil];

    
    [actionSheet showFromRect:CGRectMake(0, 20, 10, 10) inView:recognizer.view animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    Subject *thisSubject = [self.subjectButtons objectAtIndex:self.selectedSubjectIndex];
    //UICollectionViewCell *thisCell = [self.subjectCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedSubjectIndex inSection:0]];
    
    switch (buttonIndex) {
        case 0: {
            [self performSegueWithIdentifier:@"QuizEditSegue" sender:nil];
            break;
        }
        case 1: {
            NSLog(@"Taking Photo from Camera");
            [self showImagePickerEasy:UIImagePickerControllerSourceTypeCamera];
            break;
        }
        case 2: {
            NSLog(@"Taking Photo from Library");
            [self showImagePickerEasy:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        }
        case 3: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Button Text" message:@"Enter text to display in button" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];

            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [alert show];
            break;
        }
        case 4: {
            // If the button doesn't have text, call it Unnamed for the delete alert.
            if (thisSubject.subjectName.length == 0) {
                thisSubject.subjectName = @"Unnamed";
            }
            [OHAlertView showAlertWithTitle:@"Delete Button" message:[NSString stringWithFormat:@"Delete button: %@?", thisSubject.subjectName] cancelButton:@"Cancel" okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self.subjectButtons removeObjectAtIndex:self.selectedSubjectIndex];
                    //[self.subjectCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.selectedSubjectIndex inSection:0]]];
                    self.selectedSubjectIndex = 0;
                    self.selectedSubject = nil;
                    [self.subjectCollectionView reloadData];
                }
            }];
            break;
        }
        case 5:
            NSLog(@"Canceled");
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    Subject *thisSubject = [self.subjectButtons objectAtIndex:self.selectedSubjectIndex];
    if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput) {
        thisSubject.subjectName = [[alertView textFieldAtIndex:0] text];
    }
    
    [self.subjectCollectionView reloadData];
}

//- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
//{
////    if (self.imageView.isAnimating)
////        [self.imageView stopAnimating];
////	
////    if (self.capturedImages.count > 0)
////        [self.capturedImages removeAllObjects];
//    
//    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
//    {
//        [self.overlayViewController setupImagePicker:sourceType];
//        [self presentViewController:self.overlayViewController animated:YES completion:^{
//            NSLog(@"Camera Completed");
//        }];
//    }
//}

#pragma mark -
#pragma mark OverlayViewControllerDelegate

- (void)showImagePickerEasy:(UIImagePickerControllerSourceType)sourceType {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"Easy Picture Done");
        }];
        
    } else
        
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        // We are using an iPad
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if (_photoLibraryPopover == nil) {
            _photoLibraryPopover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        }
        _photoLibraryPopover.delegate=self;
        [_photoLibraryPopover presentPopoverFromRect:((UICollectionView *)self.subjectCollectionView).bounds inView:self.subjectCollectionView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [_photoLibraryPopover dismissPopoverAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Image Picker Cancelled");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    Subject *subjectForImage = [self.subjectButtons objectAtIndex:self.selectedSubjectIndex];

    // This means that the image was picked from the Camera Roll
    NSString *assetURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    // If there is no imageUrl, this was taken from the camera and needs to be saved.
    if (assetURL == nil) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[pickedImage CGImage] orientation:(ALAssetOrientation)[pickedImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError   *error) {
            if (error) {
                NSLog(@"error");
            }
            else
            {
                [subjectForImage setAssetUrl:[NSString stringWithFormat:@"%@", assetURL]];
            
                [_photoLibraryPopover dismissPopoverAnimated:YES];
            
                [imagePicker dismissViewControllerAnimated:YES completion:^{
                
                
                }];

            }
        }];
    }
    else
    {
        // Use the url of the picture that was loaded from the Camera Roll
        
        [subjectForImage setAssetUrl:[NSString stringWithFormat:@"%@", assetURL]];
        
        [_photoLibraryPopover dismissPopoverAnimated:YES];
        
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            
            
        }];
        
    }
    
//    self.selectedSubject.subjectImage = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 50.0f);
    
    [self.subjectCollectionView reloadData];

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.subjectButtons count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SubjectMenuCell *cell = nil;
    
    Subject *subject = [self.subjectButtons objectAtIndex:indexPath.row];
    
    if (subject.isAddButton) {
        
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"AddCellID" forIndexPath:indexPath];
    }
    else {

        cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
        
        UILongPressGestureRecognizer *longPressGesture =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showTopicButtonEditActionSheet:)];
        [cell addGestureRecognizer:longPressGesture];
        
        if ([subject.assetUrl length] > 0) {
            
            NSURL *url = [[NSURL alloc] initWithString:subject.assetUrl];
            
            typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
            typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
            
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
                
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullResolutionImage];
                UIImage *myImage;
                
                if (iref){
                    
                    myImage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
                    
                    NSLog(@"Showing image for Asset URL: %@", url);
                    
                    [cell.backgroundImage setImage:myImage];
                    
                }
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror){
                
            };
            
            
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:url
                           resultBlock:resultblock
             
                          failureBlock:failureblock];
            
        }
        
        cell.buttonLabel.text = subject.subjectName;
    
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = cell.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        [cell.backgroundView.layer insertSublayer:gradient atIndex:0];
    
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedSubject = [self.subjectButtons objectAtIndex:indexPath.row];
    self.selectedSubjectIndex = indexPath.row;

    if (self.selectedSubject.isAddButton) {
        Subject *newSubject = [[Subject alloc] init];
        [self.subjectButtons insertObject:newSubject atIndex:indexPath.row];
        [self.subjectCollectionView reloadData];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add Quiz", @"Take Photo", @"Choose Existing Photo", @"Enter Text", @"Delete", nil];

        [actionSheet showFromRect:CGRectMake(20, 20, 10, 10) inView:self.subjectCollectionView animated:YES];
    }
}

// the user tapped a collection item, load and set the image on the detail view controller
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"QuizEditSegue"])
    {
        NSIndexPath *selectedIndexPath = [[self.subjectCollectionView indexPathsForSelectedItems] objectAtIndex:0];

        QuizEditViewController *quizController = [segue destinationViewController];
        quizController.delegate = self;

    }
}

- (void)didCompleteAddQuiz {

    [self dismissViewControllerAnimated:YES completion:^{
    }];
}



@end