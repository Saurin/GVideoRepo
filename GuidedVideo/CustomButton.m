//
//  CustomButton.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 1/19/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "CustomButton.h"
#import "OHAlertView.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation CustomButton {
    NSInteger _index;
    UILongPressGestureRecognizer *longPressGesture;
    
    UIImagePickerController *imagePicker;
    UIPopoverController *photoLibraryPopover;
}

@synthesize bEmptyButton, lblText, imageView, editable=_editable, delegate, presentingController, buttonType;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        
    }
    return self;
}

-(void)createButtonAtIndex:(NSInteger)index {
    _index=index;
    lblText=[[UILabel alloc] init];
    bEmptyButton=YES;
    
    [self setBackgroundColor:[UIColor blackColor]];

    [lblText setBackgroundColor:[UIColor clearColor]];
    [lblText setTextColor:[UIColor whiteColor]];
    lblText.textAlignment=UITextAlignmentCenter;
    [self bringSubviewToFront:lblText];
    [self addSubview:lblText];
    
    imageView=[[UIImageView alloc] init];
    [self addSubview:imageView];

    [self makeRoundRectView];
    if(_editable) [self addGestureRecognizer];
}

-(void)makeRoundRectView {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

-(void)setEditable:(BOOL)editable {
    _editable=editable;
    if(!editable){
        [self removeGestureRecognizer:longPressGesture];
    }
    else{
        [self addGestureRecognizer];
    }
}

-(NSInteger)getIndex {
    return _index;
}

-(void)addText:(NSString*)text {

    lblText.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [lblText setFont:[UIFont boldSystemFontOfSize:15]];

    
    lblText.text=text;
}

-(void)addImageUsingAssetURL:(NSString*)url {
    
    typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
    typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
        
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        UIImage *myImage;
        
        if (iref){
            myImage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
            [self loadImage:myImage];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror){
        
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:[NSURL URLWithString:url]
                   resultBlock:resultblock
                  failureBlock:failureblock];

}

-(void)loadImage:(UIImage*)img {
    
    imageView.frame = self.bounds;
    [self addText:@""];
    imageView.image = img;
}

-(void)addNewButton {

    lblText.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [lblText setFont:[UIFont boldSystemFontOfSize:95]];
    
    lblText.text=@"+";
}

-(void) addGestureRecognizer {
    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showTopicButtonEditActionSheet:)];
    [self addGestureRecognizer:longPressGesture];
}

- (void)showTopicButtonEditActionSheet:(UITapGestureRecognizer *)recognizer {
    
    UIActionSheet *actionSheet;
    if(self.buttonType==CustomButtonTypeSubject){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Add Quiz", @"Take Photo", @"Choose Existing Photo", @"Enter Text", nil];
    }
    else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Delete"
                                         otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil];
    }
    
    self.normalActionSheet = actionSheet;
    [self.normalActionSheet showFromRect:self.bounds inView:self animated:YES];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:{

            [OHAlertView showAlertWithTitle:@"Delete Button" message:@"Are you sure you want to delete this button?" cancelButton:@"Cancel" okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self.delegate removeButton:self];
                }
            }];
            
            break;
        }
        case 1: {
            
            if(self.buttonType==CustomButtonTypeSubject)
                [self.delegate createQuiz:self];
            else
                [self showImagePickerEasy:UIImagePickerControllerSourceTypeCamera];
            
            break;
        }
        case 2: {
            
            if(self.buttonType==CustomButtonTypeSubject)
                [self showImagePickerEasy:UIImagePickerControllerSourceTypeCamera];
            else
                [self showImagePickerEasy:UIImagePickerControllerSourceTypePhotoLibrary];
            
            break;
        }
        case 3: {
            
            [self showImagePickerEasy:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
            
        }
        case 4: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Button Text" message:@"Enter text to display in button" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];

            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [alert show];

            
            break;
        }
        default:
            break;
    }
    
    [self.normalActionSheet dismissWithClickedButtonIndex:5 animated:YES];;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *text;
    
    if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput && buttonIndex==1) {
        text = [alertView textFieldAtIndex:0].text;
        [self addText:text];

//        Subject *thisSubject = [[Subject alloc] init];
//        thisSubject.subjectName=text;
//        thisSubject.assetUrl=@"";
//        
//        [self.delegate customButton:self saveSubject:thisSubject];
        [self.delegate saveButton:self withText:text asset:@""];
    }
}

- (void)showImagePickerEasy:(UIImagePickerControllerSourceType)sourceType {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [presentingController presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"Easy Picture Done");
        }];

    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if (photoLibraryPopover == nil) {
            photoLibraryPopover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        }
        photoLibraryPopover.delegate=self;
        [photoLibraryPopover presentPopoverFromRect:self.bounds inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // This means that the image was picked from the Camera Roll
    NSString *assetURL = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] description];
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
                [self loadImage:pickedImage];
                
//                Subject *thisSubject = [[Subject alloc] init];
//                thisSubject.subjectName=@"";
//                thisSubject.assetUrl=assetURL.absoluteString;
//                
//                [self.delegate customButton:self saveSubject:thisSubject];
                [self.delegate saveButton:self withText:@"" asset:assetURL.absoluteString];
            }
        }];
    }
    else
    {
        [self loadImage:pickedImage];

//        Subject *thisSubject = [[Subject alloc] init];
//        thisSubject.subjectName=@"";
//        thisSubject.assetUrl=assetURL;
//        
//        [self.delegate customButton:self saveSubject:thisSubject];
        [self.delegate saveButton:self withText:@"" asset:assetURL];
    }

    [photoLibraryPopover dismissPopoverAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];

}

@end
