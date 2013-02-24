

#import <UIKit/UIKit.h>
#import "TopicViewDelegate.h"
#import "TopicView.h"

@interface TopicView_iPhone : TopicView <TopicViewDelegate>

@property (nonatomic, readwrite, assign) IBOutlet id delegate;

-(void)redraw;

@end


