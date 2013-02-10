//
//  SSPhotoListViewController.h
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/8/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSFlickrPhoto.h"

@interface SSPhotoListViewController : UITableViewController

@property (strong, nonatomic) NSArray* photoArray;

- (void) photoWasSelected:(SSFlickrPhoto*)photo;

@end
