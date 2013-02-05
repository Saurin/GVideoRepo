//
//  CustomButton.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 1/19/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Subject.h"
#import "QuizOption.h"


typedef NS_ENUM(NSInteger, CustomButtonType) {
    CustomButtonTypeSubject = 0,
    CustomButtonTypeQuiz=1,
    CustomButtonTypeVideo
};

@protocol AddSubjectDelegate;
@interface CustomButton : UIView <UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UIActionSheet *normalActionSheet;

@property(nonatomic,strong) UILabel *lblText;
@property(nonatomic,strong)UIImageView *imageView;
@property (nonatomic)BOOL bEmptyButton;
@property (nonatomic)BOOL editable;

@property (nonatomic, strong) id<AddSubjectDelegate> delegate;
@property  (nonatomic,strong) UIViewController *presentingController;
@property CustomButtonType buttonType;

-(void)createButtonAtIndex:(NSInteger)index;
-(void)createSubjectButtonAtIndex:(NSInteger)index withSubject:(Subject *)subject;
-(void)createQuizButtonAtIndex:(NSInteger)index withQuiz:(QuizOption*) quiz;
-(void)addText:(NSString*)text;
-(void)addImageUsingAssetURL:(NSString*)url;
-(void)addImage:(UIImage*)image withSize:(CGSize)size;
-(void)performAction;
-(void)addNewButton;
-(NSInteger)getIndex;
-(Subject*)getSubject;
-(QuizOption*)getQuizOption;

@end


@protocol AddSubjectDelegate <NSObject>
- (void)buttonClicked:(CustomButton *)btn;

- (void)saveSubjectButton:(CustomButton *)btn withSubject:(Subject *)subject;
- (void)removeSubjectButton:(CustomButton *)btn withSubject:(Subject *)subject;
- (void)createQuizAtButton:(CustomButton *)btn forSubject:(Subject *)subject;

- (void)saveQuizButton:(CustomButton *)btn withQuizOption:(QuizOption *)quizOption;
- (void)removeQuizButton:(CustomButton *)btn withQuizOption:(QuizOption *)quizOption;

- (void)removeButton:(CustomButton *)btn;
- (void)createQuiz:(CustomButton *)btn;

-(void)saveVideoUrlForButton:(CustomButton *)btn videoUrl:(NSString *)urlString;

@end
