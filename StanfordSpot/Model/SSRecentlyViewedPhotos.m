//
//  SSRecentlyViewedPhotos.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/8/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSRecentlyViewedPhotos.h"

#define RECENT_PHOTOS_ARRAY_KEY @"recent_photos_array"

#define NUM_RECENT_PHOTOS 10

@interface SSRecentlyViewedPhotos()

@end

@implementation SSRecentlyViewedPhotos


+ (NSArray*)recentlyViewedPhotos
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray* photoArray = (NSMutableArray*)[ud arrayForKey:RECENT_PHOTOS_ARRAY_KEY];
    NSMutableArray* photoArrayWithFlickrPhotos = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in photoArray) {
        [photoArrayWithFlickrPhotos addObject:[[SSFlickrPhoto alloc] initWithPhotoDictionary:dict]];
    }
    return [NSArray arrayWithArray:photoArrayWithFlickrPhotos];
}

+ (void)addPhoto:(SSFlickrPhoto *)photo
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray* photoArray = [NSMutableArray arrayWithArray:[ud arrayForKey:RECENT_PHOTOS_ARRAY_KEY]];
    if (photoArray == nil) {
        photoArray = [[NSMutableArray alloc] init];
    }
    if ([SSRecentlyViewedPhotos photoArray:photoArray containsPhoto:photo]) {
        // If photo is already in recents, remove it from its current position
        [SSRecentlyViewedPhotos photoArray:photoArray removePhoto:photo];
    } else if ([photoArray count] >= NUM_RECENT_PHOTOS) {
        // If recent photo array is already full, remove last object
        [photoArray removeObjectAtIndex:NUM_RECENT_PHOTOS-1];
    }
    [photoArray insertObject:photo.photoDict atIndex:0];
    [ud setObject:photoArray forKey:RECENT_PHOTOS_ARRAY_KEY];
    [ud synchronize];
}

+ (BOOL) photoArray:(NSMutableArray*)photoArray containsPhoto:(SSFlickrPhoto*)photo
{
    for (NSDictionary* photoDict in photoArray) {
        SSFlickrPhoto *photoToCheck = [[SSFlickrPhoto alloc] initWithPhotoDictionary:photoDict];
        if (photoToCheck.photoID == photo.photoID) {
            return YES;
        }
    }
    return NO;
}

+ (void) photoArray:(NSMutableArray*)photoArray removePhoto:(SSFlickrPhoto*)photo
{
    for (NSDictionary* photoDict in photoArray) {
        SSFlickrPhoto *photoToCheck = [[SSFlickrPhoto alloc] initWithPhotoDictionary:photoDict];
        if (photoToCheck.photoID == photo.photoID) {
            [photoArray removeObject:photoDict];
            break;
        }
    }

}

@end
