//
//  SSPhotoListViewController.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/8/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSPhotoListViewController.h"
#import "SSPhotoDisplayViewController.h"
#import "FlickrFetcher.h"
#import "SSRecentlyViewedPhotos.h"

@interface SSPhotoListViewController ()

@end

@implementation SSPhotoListViewController


#pragma mark - Table view data source

-(void) setPhotoArray:(NSArray *)photoArray
{
    if (self.sortDescriptor) {
        _photoArray = [photoArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:self.sortDescriptor]];
    } else {
        _photoArray = photoArray;
    }
}

- (NSSortDescriptor*)sortDescriptor
{
    return [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([self.photoArray[indexPath.row] isKindOfClass:[SSFlickrPhoto class]]) {
        SSFlickrPhoto *photo = self.photoArray[indexPath.row];
        cell.textLabel.text = photo.title;
        cell.detailTextLabel.text = photo.photoDescription;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Photo Selected"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        SSFlickrPhoto* photo = (SSFlickrPhoto*)self.photoArray[indexPath.row];
        if ([segue.destinationViewController isKindOfClass:[SSPhotoDisplayViewController class]]) {
            [self photoWasSelected:photo];
            SSPhotoDisplayViewController *vc = (SSPhotoDisplayViewController*)segue.destinationViewController;
            FlickrPhotoFormat format = self.splitViewController ? FlickrPhotoFormatOriginal : FlickrPhotoFormatLarge;
            vc.imageURL = [FlickrFetcher urlForPhoto:photo.photoDict format:format];
            vc.showListsButton = self.showListsButton;
            vc.title = photo.title;
        } else {
            NSLog(@"Segue destinationController for segue: \"%@\" was not a SSPhotoDisplayViewController",segue.identifier);
        }
    } else {
        NSLog(@"Unknown Segue: %@",segue.identifier);
    }
}

- (void) photoWasSelected:(SSFlickrPhoto *)photo
{
    [SSRecentlyViewedPhotos addPhoto:photo];
}

@end
