

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject {
    NSMutableDictionary *cache;
}

+ (ImageCache *)sharedImageCache;
- (BOOL) isImageCached:(NSString*)imageURL;
- (UIImage*) getCachedImage:(NSString*)imageURL;
- (void) cacheImage:(UIImage*)image key:(NSString*)imageURL;
- (void) flushCache;

@end
