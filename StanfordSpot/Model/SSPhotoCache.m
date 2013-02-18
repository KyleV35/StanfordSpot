//
//  SSPhotoCache.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/17/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSPhotoCache.h"
#import "SSFlickrPhoto.h"

#define DIRECTORY @"photoCache"
#define CACHE_SIZE_iPHONE_MB 3
#define CACHE_SIZE_iPAD_MB 6
#define BYTES_IN_MB 1000000

@interface SSPhotoCache()

@property (strong, nonatomic) NSURL *cacheURL;
@property (nonatomic) NSUInteger cacheMaxSizeInMB;

@end

@implementation SSPhotoCache

static SSPhotoCache* sharedInstance;

/* Initialize shared instance with initialize, called once per class */
+(void)initialize
{
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedInstance = [[SSPhotoCache alloc] init];
        if ([UIScreen mainScreen].bounds.size.width < 500) {
            sharedInstance.cacheMaxSizeInMB = CACHE_SIZE_iPHONE_MB;
        } else {
            sharedInstance.cacheMaxSizeInMB = CACHE_SIZE_iPAD_MB;
        }
    }
    
}

+(id)sharedInstance {
    return sharedInstance;
}

-(BOOL)photoIsInCache:(NSURL *)photoURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Hash of photoURL is uniqueIdentifier for photo
    NSUInteger hash= [photoURL hash];
    NSURL *path = [self.cacheURL URLByAppendingPathComponent:
                      [NSString stringWithFormat:@"%u",hash]];
    return [fileManager isReadableFileAtPath:[path path]];
}

-(NSURL*)cacheURL
{
    if (!_cacheURL) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //Get URL for our cache directory
        NSArray *urls = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        NSURL* cacheURL = urls[0];
        NSURL* photoCacheURL = [cacheURL URLByAppendingPathComponent:DIRECTORY isDirectory:YES];
        
        // If directory doesn't exist, create it!
        if (![fileManager fileExistsAtPath:[photoCacheURL absoluteString] isDirectory:NULL]) {
            [fileManager createDirectoryAtURL:photoCacheURL withIntermediateDirectories:NO attributes:nil error:nil];
        }
        _cacheURL = photoCacheURL; //Only 1 url in iOS
    }
    return _cacheURL;
}

-(NSData*)dataForPhotoInCache:(NSURL *)photoURL
{
    //Hash of photoURL is uniqueIdentifier for photo
    NSUInteger hash= [photoURL hash];
    NSURL *cacheURLForFile = [self.cacheURL URLByAppendingPathComponent:
                       [NSString stringWithFormat:@"%u",hash]];
    NSData* data = [NSData dataWithContentsOfURL:cacheURLForFile];
    return data;
}

-(BOOL)putPhotoDataInCache:(NSData *)imageData withURL:(NSURL *)photoURL
{
    NSUInteger hash= [photoURL hash];
    NSURL *cacheURLForFile = [self.cacheURL URLByAppendingPathComponent:
                              [NSString stringWithFormat:@"%u",hash]];
    NSUInteger sizeOfData = [imageData length];
    
    // If we are over the cache size limit, evict oldest cache item
    while ([self currentCacheSize] + sizeOfData > self.cacheMaxSizeInMB * BYTES_IN_MB) {
        [self evictOldestCacheItem];
    }
    return [imageData writeToURL:cacheURLForFile atomically:YES];
}

-(NSUInteger)currentCacheSize
{
    //Find current cache size by summing size of each file in cache
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dict= [fileManager contentsOfDirectoryAtURL:self.cacheURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    NSUInteger totalSize = 0;
    for (NSURL* url in dict) {
        NSDictionary* dict = [fileManager attributesOfItemAtPath:[url path] error:nil];
        NSUInteger size = [dict fileSize];
        totalSize += size;
    }
    return totalSize;
}

-(void)evictOldestCacheItem
{
    //Iterate through each item in cache, find oldest, and evict it from cache
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dict= [fileManager contentsOfDirectoryAtURL:self.cacheURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    NSURL *oldestItemURL = nil;
    NSDate *oldestItemDate = nil;
    for (NSURL *url in dict) {
        NSDictionary *dict = [fileManager attributesOfItemAtPath:[url path] error:nil];
        NSDate *modDate = [dict fileModificationDate];
        if (!oldestItemDate || [oldestItemDate compare:modDate] == NSOrderedDescending) {
            oldestItemURL = url;
            oldestItemDate = modDate;
        }
    }
    if (![fileManager removeItemAtURL:oldestItemURL error:nil]) {
        NSLog(@"Could not delete item at %@ from cache", [oldestItemURL path]);
    }
}

@end
