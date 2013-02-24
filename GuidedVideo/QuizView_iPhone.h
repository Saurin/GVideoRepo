//
//  QuizView_iPhone.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 2/24/13.
//  Copyright (c) 2013 Mark Wade. All rights reserved.
//

#import "QuizView.h"
#import "CustomButton.h"

@interface QuizView_iPhone : QuizView<AddSubjectDelegate>

@property (nonatomic, readwrite, assign) IBOutlet id delegate;

-(void)redraw;

@end