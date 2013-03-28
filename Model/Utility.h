
#import <Foundation/Foundation.h>

@interface Utility : NSObject

typedef void (^UtilityImageHandler)(NSString *url, UIImage *image);
@property (nonatomic, copy) UtilityImageHandler utilityImageHandler;

-(void)getImageFromAssetURL:(NSString*)url completion:(UtilityImageHandler)completionBlock;
-(UIImage *)getThumbnailFromVideoURL:(NSString*)url;

@end