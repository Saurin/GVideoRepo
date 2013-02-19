

#import "ImageCache.h"

@implementation ImageCache

+ (ImageCache *)sharedImageCache
{
    static ImageCache *sharedImageCache = nil;
    
    @synchronized(self)
    {
        if (!sharedImageCache)
            sharedImageCache = [[ImageCache alloc] init];
        
        return sharedImageCache;
    }
}

- (id) init
{
    self = [super init];
    
    cache = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void) flushCache
{
    [cache removeAllObjects];
    cache = nil;
    
    cache = [[NSMutableDictionary alloc] init];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (BOOL) isImageCached:(NSString*)imageURL
{
    bool exist = NO;
    @synchronized(self)
    {
        if([[cache allKeys] containsObject:imageURL])
            exist = YES;
    }
    
    return exist;
}

- (UIImage*) getCachedImage:(NSString*)imageURL
{
    if ([self isImageCached:imageURL])
        return [cache objectForKey:imageURL];
    else
        return nil;
}

- (void) cacheImage:(UIImage*)image key:(NSString*)imageURL
{
    [cache setObject:image forKey:imageURL];
}


@end
