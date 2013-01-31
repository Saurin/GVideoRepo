//
//  PresentViewController.m
//  GuidedVideo
//
//  Created by Mark Wade on 12/9/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import "PresentViewController.h"
#import "EditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SubjectMenuCell.h"

@interface PresentViewController ()

@end

@implementation PresentViewController

@synthesize subjectButtons, selectedSubject;


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
    self.subjectButtons = [[NSMutableArray alloc] init];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    [self displayContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
//    [EditViewController class];
//    [self performSegueWithIdentifier:@"EditPresentationSegue" sender:self];
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"EditPresentationSegue"]) {
        
        EditViewController *evc = [segue destinationViewController];
        evc.delegate = self;
        
    }
}

#pragma mark - EditPresentationDelegate

-(void)didUpdatePresentation {

    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Modal Dismissed");
    }];
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
        
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"SubjectCellID" forIndexPath:indexPath];
        
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

        cell.backgroundColor = [UIColor darkGrayColor];
        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = cell.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
//        [cell.backgroundView.layer insertSublayer:gradient atIndex:0];
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedSubject = [self.subjectButtons objectAtIndex:indexPath.row];
    
//    if (self.selectedSubject.isAddButton) {
//        Subject *newSubject = [[Subject alloc] init];
//        [self.subjectButtons insertObject:newSubject atIndex:indexPath.row];
//        [self.subjectCollectionView reloadData];
//    }
//    else {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"Cancel"
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles:@"Take Photo", @"Choose Existing Photo", @"Enter Text", @"Delete", nil];
//        
//        [actionSheet showFromRect:CGRectMake(20, 20, 10, 10) inView:self.subjectCollectionView animated:YES];
//    }
}


#pragma mark - Display interface

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

@end
