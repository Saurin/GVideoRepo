//
//  PresentViewController.h
//  GuidedVideo
//
//  Created by Mark Wade on 12/9/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"

@interface PresentViewController : UIViewController <UICollectionViewDelegate>

@property (nonatomic, retain) NSMutableArray *subjectButtons;
@property (strong, nonatomic) IBOutlet UICollectionView *subjectCollectionView;
@property (nonatomic, retain) Subject *selectedSubject;

@end
