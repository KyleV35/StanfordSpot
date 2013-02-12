//
//  SSPhotoListViewController.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/7/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSTagListViewController.h"
#import "SSPhotoListViewController.h"
#import "FlickrFetcher.h"
#import "SSRecentlyViewedPhotos.h"

@interface SSTagListViewController ()

@property (strong, nonatomic) NSDictionary* tagDictionary;

/* If tagDictionary is changed, tagList must be set to nil and repopulated*/
@property (strong, nonatomic) NSArray *tagList;

@end

@implementation SSTagListViewController

#pragma mark Lazy Instantiation

- (NSDictionary*)tagDictionary
{
    if (!_tagDictionary) {
        self.tagList = nil;
        NSArray *photos = [self getPhotoArray];
        _tagDictionary = [self createTagListDictionaryWithPhotoArray:photos];
    }
    return _tagDictionary;
}

- (NSArray*)tagList
{
    if (!_tagList) {
        _tagList = [[self.tagDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    return _tagList;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tagList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tag List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Configure Cell
    NSString* tag = [self tagList][indexPath.row];
    cell.textLabel.text = [tag capitalizedString];
    
    NSUInteger numPhotosForTag = [(NSArray*)self.tagDictionary[tag] count];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%u Photos",numPhotosForTag];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Tag Selected"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSString *tag = self.tagList[indexPath.row];
        NSArray *photoArrayForTag = self.tagDictionary[tag];
        if ([segue.destinationViewController isKindOfClass:[SSPhotoListViewController class]]) {
            SSPhotoListViewController *vc = (SSPhotoListViewController*)segue.destinationViewController;
            vc.photoArray = photoArrayForTag;
            vc.title = [tag capitalizedString];
        } else {
            NSLog(@"Segue destinationViewController for segue: \"%@\" was not an SSPhotoListViewController!",segue.identifier);
            exit(1);
        }
    } else {
        NSLog(@"Unknown segue identifier: %@",segue.identifier);
    }
}

#pragma mark Helper Methods

/* Returns an array of SSFlickrPhotos */
- (NSArray*) getPhotoArray
{
    NSArray *photoDicts = [FlickrFetcher stanfordPhotos];
    NSMutableArray *mutablePhotoDicts = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in photoDicts) {
        SSFlickrPhoto* photo = [[SSFlickrPhoto alloc] initWithPhotoDictionary:dict];
        [mutablePhotoDicts addObject:photo];
    }
    return [NSArray arrayWithArray:mutablePhotoDicts];
}

/* Create a dictionary that maps from tags to an array of photos associated with those tags.  This is completed by iterating through each photo, grabbing its tags, then adding that same photo to the photo array for each tag. */
- (NSDictionary*)createTagListDictionaryWithPhotoArray:(NSArray*)photos
{
    NSMutableDictionary *newTagDictionary = [[NSMutableDictionary alloc] init];
    for (SSFlickrPhoto* photo in photos) {
        for (NSString* tag in photo.tags) {
            NSMutableArray* value = [newTagDictionary objectForKey:tag];
            if (value == nil) {
                value = [NSMutableArray arrayWithObject:photo];
            } else {
                [value addObject:photo];
            }
            [newTagDictionary setObject:value forKey:tag];
        }
    }
    return [NSDictionary dictionaryWithDictionary:newTagDictionary];
}
                    


@end
