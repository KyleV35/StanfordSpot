//
//  SSNetworkActivityCounter.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/14/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSNetworkActivityCounter.h"

@interface SSNetworkActivityCounter()

@property (atomic,readwrite) NSUInteger networkActivityCount;

@end

static SSNetworkActivityCounter* _sharedInstance;

@implementation SSNetworkActivityCounter

+ (SSNetworkActivityCounter*)sharedInstance
{
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[SSNetworkActivityCounter alloc] init];
            _sharedInstance.networkActivityCount = 0;
        }
        return _sharedInstance;
    }
}

- (void)increment
{
    @synchronized(self) {
        self.networkActivityCount+=1;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (void)decrement
{
    @synchronized(self) {
        self.networkActivityCount-=1;
        if (self.networkActivityCount == 0) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }
}

@end
