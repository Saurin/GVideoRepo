
#import "Utility.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageCache.h"

@implementation Utility

- (id)init
{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

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
