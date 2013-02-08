//
//  SSFlickrPhoto.h
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/8/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSFlickrPhoto : NSObject

@property (strong, nonatomic, readonly) NSDictionary* photoDict;

//Easy accessors for properties in the dictionary
@property (weak, nonatomic, readonly) NSString* title;
@property (weak, nonatomic, readonly) NSString* photoDescription;
@property (weak, nonatomic, readonly) NSString* placeName;
@property (nonatomic, readonly) NSUInteger photoID;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (weak, nonatomic, readonly) NSString* owner;
@property (weak, nonatomic, readonly) NSString* photoPlaceName;
@property (weak, nonatomic, readonly) NSArray* tags; //of NSStrings

- (id) initWithPhotoDictionary:(NSDictionary*)photoDict;

@end
