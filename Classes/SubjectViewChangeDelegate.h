//
//  SubjectViewChangeDelegate.h
//  GuidedVideo
//
//  Created by Saurin Travadi on 3/21/13.
//
//

#import <Foundation/Foundation.h>

@protocol SubjectViewChangeDelegate <NSObject>

@optional
-(void)didSubjectChange:(Subject *)newSubject;

@end
