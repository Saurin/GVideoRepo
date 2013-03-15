
#import "Utility.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageCache.h"

@implementation Utility

-(void)setImageFromAssetURL:(NSString*)url completion:(UtilityImageHandler)completionBlock {
    
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
            
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:[NSURL URLWithString:url]
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
}

@end
