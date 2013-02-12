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
@property (strong, nonatomic) NSSortDescriptor* sortDescriptor;
@property (weak, nonatomic) UIBarButtonItem* showMasterButton;

/* Can be over-ridden by subclass if needed.  Adds selected photo to recents*/
- (void) photoWasSelected:(SSFlickrPhoto*)photo;

@end
