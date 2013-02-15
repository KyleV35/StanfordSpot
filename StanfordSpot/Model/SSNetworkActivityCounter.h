//
//  SSNetworkActivityCounter.h
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/14/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSNetworkActivityCounter : NSObject

@property (atomic, readonly) NSUInteger networkActivityCount;

+(SSNetworkActivityCounter*) sharedInstance;

-(void)increment;

-(void)decrement;

@end
