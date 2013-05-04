
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
    
    [self performSelector:@selector(loadDefaults) withObject:nil afterDelay:0.2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDefaults {
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    NSMutableArray *array = [[Data sharedData] getParameter:@"SampleSubjectLoaded"];
    if (array!=nil && array.count>0){              //already sample established

        [HUD hide:YES];
        [OHAlertView showAlertWithTitle:@"" message:@"Sample subject loaded." cancelButton:nil okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {

            [self dismissViewControllerAnimated:YES completion:^{
                //do nothing
            }];
        }];
    }
    else
    {
        //add save assets and add into DB

        //add subject
        UIImage *image = [UIImage imageNamed:@"image_0.png"];
        ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL * imageURL, NSError * error){

            if(error!=nil){
                [OHAlertView showAlertWithTitle:@"" message:@"Unable to load Sample Subject." cancelButton:nil okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        //do nothing
                    }];
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
                        
                        [self dismissViewControllerAnimated:YES completion:^{
                            //do nothing
                        }];
                    }];
                    return;
                }
                
                QuizPage *quiz = [[QuizPage alloc] initWithSubjectId:subId name:@"Touch the picture of dog" videoURL:[assetURL absoluteString]];
                NSInteger quizId = [[Data sharedData] saveQuiz:quiz];
                
                
                //Store flag that sample subject saved successfully
                [[Data sharedData] insertParameter:@"SampleSubjectLoaded" withValue:@"1" description:@"Flags that sample subject is loaded"];
                
                [HUD hide:YES];
                [self dismissViewControllerAnimated:YES completion:^{
                    //do nothing
                }];
            }];
        }];
    }
}


@end
