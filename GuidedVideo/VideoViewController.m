//
//  VideoViewController.m
//  GuidedVideo
//
//  Created by Sejal Pandya on 1/18/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "VideoViewController.h"
#define ButtonCount 16
#define VPadding 20
#define HPadding 40


@implementation VideoViewController


-(void)viewDidLoad {
    

}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setTitle:@""];

    [self loadButtons];
    [self createButtons];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)loadButtons {
    
    NSInteger tag=1;
    double buttonHeight = (self.view.frame.size.height-VPadding*6)/5;
    double buttonWidth = (self.view.frame.size.width-HPadding*6)/5;
    
    for (NSInteger i=1;i<ButtonCount;i++) {
        [[self.view viewWithTag:i] removeFromSuperview];
    }
    
    //bottom row
    for(NSInteger i=0;i<5;i++){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, self.view.frame.size.height-buttonHeight-VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    //right column
    for(NSInteger i=3;i>0;i--){
        
        CGRect frame = CGRectMake(self.view.frame.size.width-buttonWidth-HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    
    //top row
    for(NSInteger i=4;i>=0;i--){
        
        CGRect frame = CGRectMake((i*buttonWidth)+(i+1)*HPadding, VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
    
    //left column
    for(NSInteger i=1;i<=3;i++){
        
        CGRect frame = CGRectMake(HPadding,(i*buttonHeight)+(i+1)*VPadding, buttonWidth, buttonHeight);
        
        CustomButton *btn = [[CustomButton alloc] initWithFrame:frame];
        btn.tag=tag++;
        [self.view addSubview:btn];
        [btn setHidden:YES];
    }
}

-(void)createButtons {
    
    NSMutableArray *buttons = [[Data sharedData] getSubjects];
    
    for(NSInteger i=0;i<ButtonCount;i++){
        
        CustomButton *btn = (CustomButton *)[self.view viewWithTag:i+1];
        [btn createButtonAtIndex:i];
        [btn setEditable:NO];
        
        btn.presentingController=self;
        btn.buttonType=CustomButtonTypeSubject;
        
        if(buttons.count>i){
            
            Subject *sub = [buttons objectAtIndex:i];
            if([sub.subjectName isEqualToString:@""]){
                [btn addImageUsingAssetURL:sub.assetUrl];
            }
            else{
                [btn addText:sub.subjectName];
            }
            btn.bEmptyButton=NO;
            [btn setHidden:NO];
        }
        else{
            btn.bEmptyButton=YES;
            [btn setHidden:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
//-(void)video
//{
//        // We are using an iPad
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = self;
////        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
//        popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
//        popoverController.delegate=self;
//        [popoverController presentPopoverFromRect:CGRectNull inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//	
//}
//
//
//-(void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info
//{
//    
//    
//    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
//    
//    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0)
//        == kCFCompareEqualTo)
//    {
//        
//        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
//        
//        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
//        NSLog(@"%@",moviePath);
//        
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
//            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
//        }
//    }
//    
//    
//    [self dismissModalViewControllerAnimated:YES];
//    
//    
//    
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

-(IBAction)didEditClick:(id)sender {
    [self setTitle:@"Done"];
    [self performSegueWithIdentifier:@"Edit" sender:nil];
}

@end
