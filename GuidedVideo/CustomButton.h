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

typedef NS_ENUM(NSInteger, CustomButtonType) {
    CustomButtonTypeSubject = 0,
    CustomButtonTypeQuiz
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
-(void)addText:(NSString*)text;
-(void)addImageUsingAssetURL:(NSString*)url;

-(void)addNewButton;
-(NSInteger)getIndex;
@end


@protocol AddSubjectDelegate <NSObject>
- (void)buttonClicked:(CustomButton *)btn;
//- (void)customButton:(CustomButton *)btn saveSubject:(Subject *)subject;
- (void)saveButton:(CustomButton *)btn withText:(NSString *)text asset:(NSString *)assetUrl;
- (void)removeButton:(CustomButton *)btn;
- (void)createQuiz:(CustomButton *)btn;
@end
