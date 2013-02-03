//
//  ViewController.m
//  GuidedVideo
//
//  Created by Mark Wade on 12/9/12.
//  Copyright (c) 2012 Mark Wade. All rights reserved.
//

#import "ViewController.h"
#import "Data.h"
#import "Subject.h"

@implementation ViewController {
    NSMutableArray *btnClickedAt;
    NSNumber *defaultValue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    defaultValue=[NSNumber numberWithDouble:100000];
    btnClickedAt = [NSMutableArray arrayWithObjects:defaultValue, defaultValue, defaultValue, defaultValue, nil];
    

//    Subject *sub = [[Subject alloc] init];
//    sub.subjectName=@"Test";
//    sub.assetUrl=@"temp.jpg";
//    
//    //[[Data sharedData] saveSubjectAtIndex:0 subject:sub];
//    
//    NSMutableArray *subjects;
//    subjects = [[Data sharedData] getSubjects];
//    for(NSInteger i=0;i<subjects.count;i++){
//    
//        Subject *sub = [subjects objectAtIndex:i];
//        NSLog(@"%d %@ %@",sub.subjectId,sub.subjectName, sub.assetUrl);
//    }
//    
//    //[[Data sharedData] deleteSubjectAtIndex:1];
//
//    sub.subjectName=@"new name";
//    sub.assetUrl=@"";
//    [[Data sharedData] saveSubjectAtIndex:4 subject:sub];
//    
//    subjects = [[Data sharedData] getSubjects];
//    for(NSInteger i=0;i<subjects.count;i++){
//        
//        Subject *sub = [subjects objectAtIndex:i];
//        NSLog(@"%d %@ %@",sub.subjectId,sub.subjectName, sub.assetUrl);
//    }
    
    
//    Subject *sub = [[Subject alloc] init];
//    sub.subjectName=@"Test";
//    sub.assetUrl=@"http://www.yahoo.com";
//    [[Data sharedData] saveSubjectAtIndex:0 subject:sub];
//    
//    NSMutableArray *quizzes=[[NSMutableArray alloc] init];
//    for(NSInteger j=0;j<5;j++){
//        Quiz *quiz = [[Quiz alloc] init];
//        quiz.videoUrl=@"www.iaai.com";
//        quiz.assetUrls = [NSMutableArray arrayWithObjects:@"one",@"two", nil];
//        [quizzes addObject:quiz];
//    }
//    sub.quizzes = quizzes;
//
//    [[Data sharedData] saveSubjectAtIndex:0 subject:sub];
//    
//    
//    subjects = [[Data sharedData] getSubjects];

    
}

-(void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)didLogin {
    
    [self performSegueWithIdentifier:@"Home" sender:nil];
}

-(IBAction)didButtonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
#if (TARGET_IPHONE_SIMULATOR)
    [self didEditClick:sender];
    return;
#endif
    
    double currentTime = CACurrentMediaTime();
    [btnClickedAt replaceObjectAtIndex:tag-1 withObject:[NSNumber numberWithDouble:currentTime]];
    [self performSelector:@selector(resetButtonClickAt:) withObject:[NSNumber numberWithInt:tag-1] afterDelay:2];
    
    CFShow((__bridge CFTypeRef)(btnClickedAt));
    
    if(![[btnClickedAt objectAtIndex:0] isEqualToNumber:defaultValue]
       && ![[btnClickedAt objectAtIndex:1] isEqualToNumber:defaultValue]
       && ![[btnClickedAt objectAtIndex:2] isEqualToNumber:defaultValue]
       && ![[btnClickedAt objectAtIndex:3] isEqualToNumber:defaultValue]){
        
        if([[btnClickedAt objectAtIndex:0] doubleValue]<[[btnClickedAt objectAtIndex:1] doubleValue]
           && [[btnClickedAt objectAtIndex:1] doubleValue]<[[btnClickedAt objectAtIndex:2] doubleValue]
           && [[btnClickedAt objectAtIndex:2] doubleValue]<[[btnClickedAt objectAtIndex:3] doubleValue])
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetButtonClickAt:) object:[NSNumber numberWithInt:0]];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetButtonClickAt:) object:[NSNumber numberWithInt:1]];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetButtonClickAt:) object:[NSNumber numberWithInt:2]];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetButtonClickAt:) object:[NSNumber numberWithInt:3]];
            
            [self didEditClick:sender];
        }
    }
}

-(void)resetButtonClickAt:(NSNumber*)tag {
    [btnClickedAt replaceObjectAtIndex:[tag integerValue] withObject:defaultValue];
}



@end
