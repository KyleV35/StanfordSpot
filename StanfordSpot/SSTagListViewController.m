//
//  SSPhotoListViewController.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/7/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSTagListViewController.h"
#import "FlickrFetcher.h"
#import "SSFlickrPhoto.h"

@interface SSTagListViewController ()

@property (strong, nonatomic) NSDictionary* tagDictionary;

/* If tagDictionary is changed, tagList must be set to nil and repopulated*/
@property (strong, nonatomic) NSArray *tagList;

@end

@implementation SSTagListViewController

#pragma mark Lazy Instantiation

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

- (NSDictionary*)tagDictionary
{
    if (!_tagDictionary) {
        self.tagList = nil;
        NSArray *photos = [self getPhotoArray];
        _tagDictionary = [self createTagListDictionaryWithPhotoArray:photos];
    }
    return _tagDictionary;
}

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

- (NSArray*)tagList
{
    if (!_tagList) {
        _tagList = [self.tagDictionary allKeys];
    }
    return _tagList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"Photo List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Configure Cell
    NSString* tag = [self tagList][indexPath.row];
    cell.textLabel.text = [tag capitalizedString];
    
    NSUInteger numPhotosForTag = [(NSArray*)self.tagDictionary[tag] count];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%u Photos",numPhotosForTag];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
