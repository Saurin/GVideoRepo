
#import "Utility.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>  
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageCache.h"
#import "AppDelegate.h"
#include <sys/utsname.h>

@implementation Utility

- (id)init
{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

-(void)getImageFromAssetURL:(NSString*)url completion:(UtilityImageHandler)completionBlock {
    
    self.utilityImageHandler = completionBlock;
    
    typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
    typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
    
    if([[ImageCache sharedImageCache] isImageCached:url])
    {
        UIImage *myImage = [[ImageCache sharedImageCache] getCachedImage:url];

        self.utilityImageHandler(url,myImage);
    }
    else{
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
            
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            UIImage *myImage;
            
            if (iref){
                
                myImage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
                [[ImageCache sharedImageCache] cacheImage:myImage key:url];

                self.utilityImageHandler(url,myImage);
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror){
            UIImage *myImage = [UIImage imageNamed:@"dummy.jpg"];
            self.utilityImageHandler(url,myImage);
        };
        
        if([url isEqualToString:@""]){
            UIImage *myImage = [UIImage imageNamed:@"dummy.jpg"];
            self.utilityImageHandler(url,myImage);
        }
        else{
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:[NSURL URLWithString:url]
                           resultBlock:resultblock
                          failureBlock:failureblock
             ];
        }
        
    }
}

-(void)getThumbnailFromVideoURL:(NSString*)url completion:(UtilityImageHandler)completionBlock {
    
    self.utilityImageHandler = completionBlock;

    UIImage *thumbnail;
    if([[ImageCache sharedImageCache] isImageCached:url])
    {
        thumbnail = [[ImageCache sharedImageCache] getCachedImage:url];
        self.utilityImageHandler(url,thumbnail);
    }
    else{

        if(url!=nil && ![url isEqualToString:@""]){

            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url]];
            player.shouldAutoplay=NO;
            
            thumbnail = [player thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionExact];
            
            [[ImageCache sharedImageCache] cacheImage:thumbnail key:url];
            [player stop];
            player=nil;
            
            self.utilityImageHandler(url,thumbnail);
        }
        else{
            self.utilityImageHandler(url,nil);
        }
    }
}


-(void)setUserSettings:(NSInteger)keyValue keyName:(NSString *)keyName{
    [[NSUserDefaults standardUserDefaults] setInteger:keyValue forKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)getUserSettings:(NSString *)keyName{
    return [[NSUserDefaults standardUserDefaults] integerForKey:keyName];
}

-(BOOL)userSettingsExists:(NSString *)keyName {
    if([[NSUserDefaults standardUserDefaults] objectForKey:keyName] != nil) {
        return YES;
    }
    return NO;
}

+ (NSString*)device{
    return [[UIDevice currentDevice]model];
}

+ (NSString*)deviceModel{
    struct utsname utsDevice;
    uname(&utsDevice);
    NSString *platform = [NSString stringWithUTF8String:utsDevice.machine];
    return platform;
}

+(NSString*)deviceOS{
    return [[UIDevice currentDevice]systemVersion];
}

+(NSString*)appVersion{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

//get all images from photo library
-(void)getAllImages {
    
    void (^myAssetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != NULL)
        {
            NSLog(@"See Asset: %@", result);
            
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
                
            }
        }
    };
    
    //This block of code used to enumerate ALAssetsGroup.
    void (^myAssetGroupEnumerator)( ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group enumerateAssetsUsingBlock:myAssetEnumerator];
            
            
            
        }
    };
    
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:myAssetGroupEnumerator
                         failureBlock: ^(NSError *error) {
                             NSLog(@"Failure");
                         }
     ];

}


@end
