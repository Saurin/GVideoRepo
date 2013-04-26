
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
    
    NSError *err=nil;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    NSString *copypath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Samples"];
    
    if([fileMgr fileExistsAtPath:copypath]) {
        [HUD hide:YES];
        [OHAlertView showAlertWithTitle:@"" message:@"Sample subject loaded." cancelButton:nil okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                //do nothing
            }];
        }];
    }
    else
    {
    
        [fileMgr removeItemAtPath:copypath error:&err];
        if(![fileMgr copyItemAtPath:path toPath:copypath error:&err])
        {
            [HUD hide:YES];
            [OHAlertView showAlertWithTitle:@"" message:@"Unable to load Sample Subject." cancelButton:nil okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {

                [self dismissViewControllerAnimated:YES completion:^{
                    //do nothing
                }];
            }];
            
            return;
        }
        
        
        //add save assets and add into DB
        //add subject
        NSString *url = [copypath stringByAppendingPathComponent:@"image-0.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:url];
        ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL * assertURL, NSError * error){

            if(error!=nil){
                [OHAlertView showAlertWithTitle:@"" message:@"Unable to load Sample Subject." cancelButton:nil okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        //do nothing
                    }];
                }];
                return;
            }
            
            Subject *subject = [[Subject alloc] initWithName:@"Sample Subject" assetURL:[assertURL absoluteString]];
            NSInteger subId = [[Data sharedData] saveSubject:subject];
            
            //now create instruction
            NSString *videoURL = [copypath stringByAppendingPathComponent:@"dog.mov"];
            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoURL] completionBlock:^(NSURL *assetURL, NSError *error1) {

                if(error1!=nil){
                    [OHAlertView showAlertWithTitle:@"" message:@"Unable to load Sample Subject." cancelButton:nil okButton:@"OK" onButtonTapped:^(OHAlertView *alert, NSInteger buttonIndex) {
                        
                        [self dismissViewControllerAnimated:YES completion:^{
                            //do nothing
                        }];
                    }];
                    return;
                }

                QuizPage *quiz = [[QuizPage alloc] initWithSubjectId:subId name:@"Touch the picture of dog" videoURL:[assertURL absoluteString]];
                NSInteger quizId = [[Data sharedData] saveQuiz:quiz];
                
                [HUD hide:YES];
                [self dismissViewControllerAnimated:YES completion:^{
                    //do nothing
                }];
            }];
        }];
    }
}


@end
