//
//  SSRecentPhotoListViewController.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/8/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSRecentPhotoListViewController.h"
#import "SSRecentlyViewedPhotos.h"

@interface SSRecentPhotoListViewController ()

@end

@implementation SSRecentPhotoListViewController

-(void) viewWillAppear:(BOOL)animated
{
    self.photoArray = [SSRecentlyViewedPhotos recentlyViewedPhotos];
    [self.tableView reloadData];
    [self.tableView scrollsToTop];
}

- (void) photoWasSelected:(SSFlickrPhoto *)photo
{
    //Do nothing
}

@end
