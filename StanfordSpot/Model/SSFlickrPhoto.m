//
//  SSFlickrPhoto.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/8/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSFlickrPhoto.h"
#import "FlickrFetcher.h"

#define TAG_DELIMITER @" "

@interface SSFlickrPhoto()

@property (strong,nonatomic) NSDictionary* photoDict;

@end

@implementation SSFlickrPhoto

- (id) initWithPhotoDictionary:(NSDictionary *)photoDict
{
    self = [super init];
    if (self) {
        self.photoDict = photoDict;
    }
    return self;
}

- (NSString*) title
{
    if ([self.photoDict[FLICKR_PHOTO_TITLE] isKindOfClass:[NSString class]]) {
        return (NSString*) self.photoDict[FLICKR_PHOTO_TITLE];
    }
    return nil;
}

- (NSString*) photoDescription
{
    if ([[self.photoDict valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] isKindOfClass:[NSString class]]) {
        return (NSString*) [self.photoDict valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    }
    return nil;
}

- (NSString*) placeName
{
    if ([self.photoDict[FLICKR_PLACE_NAME] isKindOfClass:[NSString class]]) {
        return (NSString*) self.photoDict[FLICKR_PLACE_NAME];
    }
    return nil;
}

- (NSUInteger) photoID
{
    if ([self.photoDict[FLICKR_PHOTO_ID] isKindOfClass:[NSString class]]) {
        return [(NSNumber*) self.photoDict[FLICKR_PHOTO_ID] unsignedIntValue];
    }
    return 0;
}

- (double) latitude
{
    if ([self.photoDict[FLICKR_LATITUDE] isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*) self.photoDict[FLICKR_LATITUDE] doubleValue];
    }
    return 0.0f;
}

- (double) longitude
{
    if ([self.photoDict[FLICKR_LONGITUDE] isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*) self.photoDict[FLICKR_LONGITUDE] doubleValue];
    }
    return 0.0f;
}

- (NSString*) owner
{
    if ([self.photoDict[FLICKR_PHOTO_OWNER] isKindOfClass:[NSString class]]) {
        return (NSString*) self.photoDict[FLICKR_PHOTO_OWNER];
    }
    return nil;
}

- (NSString*) photoPlaceName
{
    if ([self.photoDict[FLICKR_PHOTO_PLACE_NAME] isKindOfClass:[NSString class]]) {
        return (NSString*) self.photoDict[FLICKR_PHOTO_PLACE_NAME];
    }
    return nil;
}

- (NSArray*) tags
{
    if ([self.photoDict[FLICKR_TAGS] isKindOfClass:[NSString class]]) {
        return [(NSString*) self.photoDict[FLICKR_TAGS] componentsSeparatedByString:TAG_DELIMITER];
    }
    return nil;
}




@end
