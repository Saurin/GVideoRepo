//
//  QuizEditViewController.h
//  GuidedVideo
//
//  Created by Mark Wade on 1/13/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddQuizDelegate <NSObject>
- (void)didCompleteAddQuiz;
@end

@interface QuizEditViewController : UIViewController

@property (nonatomic, retain) id <AddQuizDelegate> delegate;

- (IBAction)didClickBack:(id)sender;

@end
