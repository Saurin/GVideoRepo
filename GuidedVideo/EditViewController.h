//
//  EditViewController.h
//  GuidedVideo
//
//  Created by Mark Wade on 12/9/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Subject.h"
#import "SubjectMenuEditPopover.h"
#import "SubjectMenuViewController.h"
#import "QuizEditViewController.h"

@protocol EditPresentationDelegate <NSObject>
- (void)didUpdatePresentation;
@end

@interface EditViewController : UIViewController <UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate, AddQuizDelegate> {
    UIImagePickerController *imagePicker;
    IBOutlet UIImageView *selectedImage;
}

- (IBAction)didClickDoneButton:(id)sender;
- (IBAction)didClickAddMenu:(id)sender;

@property (nonatomic, retain) UIImageView *selectedImage;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, strong) id delegate;
@property (nonatomic, retain) NSMutableArray *subjectButtons;
@property int selectedSubjectIndex;
@property (nonatomic, retain) Subject *selectedSubject;
@property (strong, nonatomic) IBOutlet UICollectionView *subjectCollectionView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) SubjectMenuViewController *subjectMenuContent;
@property (nonatomic, retain) UIPopoverController *subjectMenuPopover;
@property (nonatomic, retain) UIPopoverController *photoLibraryPopover;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
