
#import "InitialViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import "OHAlertView.h"
#import "Data.h"

@implementation InitialViewController {
    MBProgressHUD *HUD;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD show:YES];

    //load default sample subject, if not loaded so far
    NSMutableArray *array = [[Data sharedData] getParameter:@"SampleSubjectLoaded"];
    if (array==nil || array.count==0){
        //this is to be done only once
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"Loading Sample";
        [HUD show:YES];
        
        [self performSelector:@selector(loadDefaults) withObject:nil afterDelay:0.1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadDefaults {
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    
    //add subject
    UIImage *image = [UIImage imageNamed:@"geometric.png"];
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL * imageURL, NSError * error){
        
        if(error!=nil){
            [OHAlertView showAlertWithTitle:@"" message:@"Unable to load Sample Subject." cancelButton:nil okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                
                [HUD hide:YES];
            }];
            return;
        }
        
        Subject *subject = [[Subject alloc] initWithName:@"Sample Subject" assetURL:[imageURL absoluteString]];
        NSInteger subId = [[Data sharedData] saveSubject:subject];
        
        //now create instruction
        NSString *urlStr = [path stringByAppendingPathComponent:@"dog.mov"];
        NSURL *videoURL = [NSURL fileURLWithPath:urlStr];
        [library writeVideoAtPathToSavedPhotosAlbum:videoURL completionBlock:^(NSURL *assetURL, NSError *error1){
            
            if(error1!=nil){
                [OHAlertView showAlertWithTitle:@"" message:@"Unable to load Sample Subject." cancelButton:nil okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                    
                    [HUD hide:YES];
                }];
                return;
            }
            
            QuizPage *quiz = [[QuizPage alloc] initWithSubjectId:subId name:@"Touch the picture of dog" videoURL:[assetURL absoluteString]];
            NSInteger quizId = [[Data sharedData] saveQuiz:quiz];
            
            //add alternatives
            [self saveAlternativeForQuizId:quizId index:0 completionHandler:^(BOOL complete) {
                
                //Store flag that sample subject saved successfully
                [[Data sharedData] insertParameter:@"SampleSubjectLoaded" withValue:@"1" description:@"Flags that sample subject is loaded"];
                
                [HUD hide:YES];
            }];
            
        }];
    }];
}

-(void)saveAlternativeForQuizId:(NSInteger)quizId index:(NSInteger)atIndex completionHandler:(void (^)(BOOL complete))completionHandler {
    
    UIImage *altImage = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d.png",atIndex]];
    
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[altImage CGImage] orientation:(ALAssetOrientation)[altImage imageOrientation] completionBlock:^(NSURL * imgURL, NSError *err){
        
        if(err!=nil){
            [OHAlertView showAlertWithTitle:@"" message:@"Unable to load Sample Subject." cancelButton:nil okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                
                [HUD hide:YES];
            }];
            return;
        }
        
        QuizOption * option = [[QuizOption alloc] initWithQuizId:quizId
                                                      optionName:[NSString stringWithFormat:@"Shape_%d",atIndex]
                                                  optionImageUrl:imgURL.absoluteString];
        
        [[Data sharedData] saveQuizOption:option];
        if(atIndex==11){
            completionHandler(YES);
        }
        else{
            [self saveAlternativeForQuizId:quizId index:atIndex+1 completionHandler:^(BOOL complete) {
                completionHandler(YES);
            }];
        }
    }];
    
}

@end
