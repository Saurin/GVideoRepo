
#import <UIKit/UIKit.h>
#import "TopicView.h"

@interface TopicView_iPad : TopicView <TopicViewDelegate>

@property (nonatomic, readwrite, assign) IBOutlet id delegate;

-(void)redraw;

@end


