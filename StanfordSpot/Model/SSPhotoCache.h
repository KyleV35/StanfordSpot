//
//  SSPhotoCache.h
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/17/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSPhotoCache : NSObject

+(id)sharedInstance;

/* Returns YES if photo for photoURL is in cache.  photoURL refers to imageURL on internet, not to its position in cache */
-(BOOL)photoIsInCache:(NSURL*)photoURL;
/* Returns the NSData for the photo in the cache if the photo exists, otherwise returns nil */
-(NSData*)dataForPhotoInCache:(NSURL*)photoURL;
/* Puts the NSData in the cache with photoURL as its unique identifier */
-(BOOL)putPhotoDataInCache:(NSData*)imageData withURL:(NSURL*)photoURL;

@end
