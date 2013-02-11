//
//  SSRecentlyViewedPhotos.h
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/8/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSFlickrPhoto.h"

// Use UserDefaults to store recently view photos
@interface SSRecentlyViewedPhotos : NSObject

+ (NSArray*) recentlyViewedPhotos;

+ (void)addPhoto:(SSFlickrPhoto*)photo;

@end
