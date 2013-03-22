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
#import <MobileCoreServices/UTCoreTypes.h>

@implementation CustomButton {
    
    NSInteger _index;
    NSString *buttonText;
    NSString *buttonAssetUrl;
    NSInteger _buttonChoice;
    
    Subject *thisSubject;
    QuizOption *thisQuiz;
    
    UILongPressGestureRecognizer *longPressGesture;
    
    UIPopoverController *photoLibraryPopover;
}

@synthesize bEmptyButton, lblText, imageView, editable=_editable, delegate, presentingController, buttonType;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        [imageView setHidden:YES];
        
    }
    return self;
}


-(void)createSubjectButtonAtIndex:(NSInteger)index withSubject:(Subject *)subject {
    thisSubject=subject;
    buttonText=subject.subjectName;
    buttonAssetUrl=subject.assetUrl;
    buttonType=CustomButtonTypeSubject;
    [self createButtonAtIndex:index];
}

-(void)createQuizButtonAtIndex:(NSInteger)index withQuiz:(QuizOption*) quiz {
    thisQuiz=quiz;
    buttonType=CustomButtonTypeQuiz;
    [self createButtonAtIndex:index];
}

-(void)createButtonAtIndex:(NSInteger)index {
    _index=index;
    lblText=[[UILabel alloc] init];
    bEmptyButton=NO;
    
    [self setBackgroundColor:[UIColor blackColor]];

    [lblText setBackgroundColor:[UIColor clearColor]];
    [lblText setTextColor:[UIColor whiteColor]];
    lblText.textAlignment=UITextAlignmentCenter;
    [self bringSubviewToFront:lblText];
    [self addSubview:lblText];
    
    imageView=[[UIImageView alloc] init];
    [self addSubview:imageView];

    [self makeRoundRectView];
//    if(_editable) [self addGestureRecognizer];
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

-(void)showIncomplete {
    [self.layer setBorderColor: [[UIColor redColor] CGColor]];
    [self.layer setBorderWidth: 5.0];
    
    
    //This doesnt fire touch event on CustomButton
    //    IncompleteButton *vw = [[IncompleteButton alloc] initWithFrame:self.bounds];
    //    [self addSubview:vw];
}

-(NSInteger)getIndex {
    return _index;
}

-(Subject*)getSubject {
    return thisSubject;
}

-(QuizOption*)getQuizOption {
    return thisQuiz;
}

-(NSInteger)getButtonChoice {
    return _buttonChoice;
}

-(void)addText:(NSString*)text {

    lblText.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [lblText setFont:[UIFont boldSystemFontOfSize:15]];
    lblText.text=text;
    
    if(self.imageView.hidden){
        [self.lblText setHidden:NO];
    }
}

-(void)addImageUsingAssetURL:(NSString*)url {
    
    typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
    typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
    
    if([[ImageCache sharedImageCache] isImageCached:url])
    {
        UIImage *myImage = [[ImageCache sharedImageCache] getCachedImage:url];
        [self loadImage:myImage];
    }
    else{

        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
            
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            UIImage *myImage;
            
            if (iref){
                myImage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
                [[ImageCache sharedImageCache] cacheImage:myImage key:url];
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
}

-(void)addImage:(UIImage*)image withSize:(CGSize)size {
    [self loadImage:image];
}

-(void)loadImage:(UIImage*)img {
    
    [imageView removeFromSuperview];
    imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    
    imageView.frame = self.bounds;
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.image = img;
    
    [self.lblText setHidden:YES];
}

-(void)addNewButton {
    bEmptyButton=YES;
    
    lblText.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [lblText setFont:[UIFont boldSystemFontOfSize:95]];
    [lblText setHidden:NO];
    lblText.text=@"+";
}

-(void)performAction {
    
    if(_editable){
        [self showTopicButtonEditActionSheet];
    }
}

-(void) addGestureRecognizer {
    
    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showTopicButtonEditActionSheet:)];
    [self addGestureRecognizer:longPressGesture];
}
- (void)showTopicButtonEditActionSheet:(UITapGestureRecognizer *)recognizer {
    [self showTopicButtonEditActionSheet];
}

- (void)showTopicButtonEditActionSheet {
    
    if(!self.editable) return;
    
    UIActionSheet *actionSheet;
    if(self.buttonType==CustomButtonTypeSubject){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Add Quiz", @"Take Photo", @"Choose Existing Photo", @"Enter Text", nil];

    }
    else if(self.buttonType==CustomButtonTypeQuiz){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Delete"
                                         otherButtonTitles:@"Take Photo", @"Choose Existing Photo", @"Choose Video, then Repeat Question", @"Choose Video, then Next Question", @"Choose Video, then End Quiz", nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Take Video"
                                         otherButtonTitles:@"Choose Existing Video", nil];
    }
    self.normalActionSheet = actionSheet;
    [self.normalActionSheet showFromRect:self.bounds inView:self animated:YES];

}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet  
{
    for (UIView* view in [actionSheet subviews])
    {
        if ([view isKindOfClass:NSClassFromString(@"UIAlertButton")])
        {
            if ([view respondsToSelector:@selector(title)])
            {
                NSString* title = [view performSelector:@selector(title)];
                if (([title isEqualToString:@"Delete"] || [title isEqualToString:@"Add Quiz"]) && bEmptyButton)
                {
                    [view setBackgroundColor:[UIColor grayColor]];
                    [view setAlpha:0.2];
                    [view setUserInteractionEnabled:NO];
                }
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    _buttonChoice = buttonIndex;
    if(buttonType==CustomButtonTypeSubject){
        
        [self clickedAtIndexForSubject:buttonIndex];
    }
    else if(buttonType==CustomButtonTypeQuiz){
     
        [self clickedAtIndexForQuiz:buttonIndex];
    }
    else {
        
        [self clickedAtIndexForVideo:buttonIndex];
    }
    
    [self.normalActionSheet dismissWithClickedButtonIndex:5 animated:YES];;
}

-(void)clickedAtIndexForSubject:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{

            [OHAlertView showAlertWithTitle:@"Delete Button" message:@"Are you sure you want to delete this button?" cancelButton:@"Cancel" okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger index) {
                if (index == 1) {
                    [self performSelector:@selector(didSubjectDelete) withObject:nil afterDelay:0.2];
                }
            }];
            
            break;
        }
        case 1: {
            
            [self performSelector:@selector(didSubjectNeedQuiz) withObject:nil afterDelay:0.2];
            break;
        }
        case 2: {
            
            [self showImagePickerEasy:UIImagePickerControllerSourceTypeCamera];
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
}

-(void)clickedAtIndexForQuiz:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            
            [OHAlertView showAlertWithTitle:@"Delete Button" message:@"Are you sure you want to delete this button?" cancelButton:@"Cancel" okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger index) {
                if (index == 1) {
                    [self performSelector:@selector(didQuizDelete) withObject:nil afterDelay:0.2];
                }
            }];
            
            break;
        }
        case 1: {
            
            [self showImagePickerEasy:UIImagePickerControllerSourceTypeCamera];
            break;
        }
        case 2: {
            
            [self showImagePickerEasy:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        }
        default:
            [self showVideoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
    }
}

-(void)clickedAtIndexForVideo:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{

            [self showVideoPicker:UIImagePickerControllerSourceTypeCamera];
            break;
        }
        case 1: {
            
            [self showVideoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput && buttonIndex==1) {
        buttonText = [alertView textFieldAtIndex:0].text;

        [self addText:buttonText];
        [self performSelector:@selector(didSubjectUpdate) withObject:nil afterDelay:0.2];
    }
}

- (void)showImagePickerEasy:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType=sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [presentingController presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"Easy Picture Done");
        }];

    }
    else
    {
        photoLibraryPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        photoLibraryPopover.delegate=self;
        [photoLibraryPopover presentPopoverFromRect:self.bounds inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)showVideoPicker:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [presentingController presentViewController:imagePicker animated:YES completion:^{
        }];
    }
    else
    {
        photoLibraryPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        photoLibraryPopover.delegate=self;
        [photoLibraryPopover presentPopoverFromRect:self.bounds inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [[info objectForKey:@"UIImagePickerControllerMediaType"] description];
    
    if([mediaType isEqualToString:@"public.image"])
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
                    [self loadImage:pickedImage];
                    buttonAssetUrl=url.absoluteString;
                    
                    if(buttonType==CustomButtonTypeSubject){
                        [self performSelector:@selector(didSubjectUpdate) withObject:nil afterDelay:0.2];
                    }
                   else if(buttonType==CustomButtonTypeQuiz){
                       [self performSelector:@selector(didQuizUpdate) withObject:nil afterDelay:0.2];
                   }
                }
            }];
        }
        else
        {
            [self loadImage:pickedImage];
            buttonAssetUrl=assetURL;
            
            if(buttonType==CustomButtonTypeSubject){
                [self performSelector:@selector(didSubjectUpdate) withObject:nil afterDelay:0.2];
            }
            else if(buttonType==CustomButtonTypeQuiz){
               [self performSelector:@selector(didQuizUpdate) withObject:nil afterDelay:0.2];
            }
        }
    }
    
    else if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {

        NSString *assetURL = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] description];
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        if(assetURL==nil){
            //you taking new one
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
            }
        }
        
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"%@",moviePath);
        NSLog(@"%@",videoUrl.absoluteString);

        [self performSelector:@selector(didVideoPick:) withObject:videoUrl.absoluteString afterDelay:0.2];
        
    }
    
    [photoLibraryPopover dismissPopoverAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [photoLibraryPopover dismissPopoverAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma raise delegates for subject buttons

-(void)didSubjectUpdate {

    if(thisSubject==nil)
        thisSubject = [[Subject alloc] init];
    
    thisSubject.subjectName=buttonText;
    thisSubject.assetUrl=buttonAssetUrl;
    
    [self.delegate saveSubjectButton:self withSubject:thisSubject];
}

-(void)didSubjectDelete {
    
    if(thisSubject==nil)
        thisSubject=[[Subject alloc] init];
    
    [self.delegate removeSubjectButton:self withSubject:thisSubject];
}

-(void)didSubjectNeedQuiz {
    
    if(thisSubject!=nil && thisSubject.subjectId!=0)            //to protect crash
        [self.delegate createQuizAtButton:self forSubject:thisSubject];
    
}

#pragma raise delegates for quiz buttons

-(void)didQuizUpdate {
    
    if(thisQuiz==nil)
        thisQuiz = [[QuizOption alloc] init];
    
    thisQuiz.assetUrl = buttonAssetUrl;

    [self.delegate saveQuizButton:self withQuizOption:thisQuiz];
}

-(void)didQuizDelete {
    
    if(thisQuiz==nil)
        thisQuiz=[[QuizOption alloc] init];
    
    [self.delegate removeQuizButton:self withQuizOption:thisQuiz];
}

-(void)didVideoPick:(NSString*)videoUrl {
    [self.delegate saveVideoUrlForButton:self videoUrl:videoUrl];
}

@end
