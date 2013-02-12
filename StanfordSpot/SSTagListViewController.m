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
#import "SSPhotoDisplayViewController.h"
#import "SSRecentPhotoListViewController.h"

@interface SSTagListViewController () <UISplitViewControllerDelegate>

@property (strong, nonatomic) NSDictionary* tagDictionary;

/* If tagDictionary is changed, tagList must be set to nil and repopulated*/
@property (strong, nonatomic) NSArray *tagList;

/* iPad Exclusive */
@property (weak, nonatomic) UISplitViewController* splitViewController;
@property (weak, nonatomic) SSRecentPhotoListViewController* recentsController;

@end

#define DETAIL_VIEW_CONTROLLER_INDEX 1

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

#pragma mark Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Tag Selected"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSString *tag = self.tagList[indexPath.row];
        NSArray *photoArrayForTag = self.tagDictionary[tag];
        if ([segue.destinationViewController isKindOfClass:[SSPhotoListViewController class]]) {
            SSPhotoListViewController *vc = (SSPhotoListViewController*)segue.destinationViewController;
            vc.photoArray = photoArrayForTag;
            vc.showListsButton = self.showListsButton;
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

#pragma mark UISplitViewControllerDelegate

- (void) splitViewController:(UISplitViewController *)svc
      willHideViewController:(UIViewController *)aViewController
           withBarButtonItem:(UIBarButtonItem *)barButtonItem
        forPopoverController:(UIPopoverController *)pc
{
    // Set title for bar button item
    barButtonItem.title = @"Show Lists";
    // Set current detail to new bar button item
    SSPhotoDisplayViewController *detail = svc.viewControllers[DETAIL_VIEW_CONTROLLER_INDEX];
    detail.showListsButton = barButtonItem;
    
    //Update child view controllers with new barButtonItem
    [self setShowMasterButtonForAllChildren:barButtonItem];
    
    //Update recents with new barButtonItem
    SSRecentPhotoListViewController* recents = self.recentsController;
    recents.showListsButton = barButtonItem;
}

- (void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Set current detail to nil
    SSPhotoDisplayViewController *detail = svc.viewControllers[DETAIL_VIEW_CONTROLLER_INDEX];
    detail.showListsButton = nil;
    
    //Update child view controllers with nil
    [self setShowMasterButtonForAllChildren:nil];
    
    //Update recents with nil
    SSRecentPhotoListViewController* recents = self.recentsController;
    recents.showListsButton = nil;
}

#pragma mark iPad helpers

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (UISplitViewController*) splitViewController
{
    if (!_splitViewController) {
        UIViewController* vc = self.tabBarController.parentViewController;
        if ([vc isKindOfClass:[UISplitViewController class]]) {
            _splitViewController = (UISplitViewController*)vc;
        }
    }
    return _splitViewController;
}

#define RECENTS_TAB_BAR_INDEX 1

- (SSRecentPhotoListViewController*) recentsController
{
    UINavigationController* recentsNav = self.tabBarController.viewControllers[RECENTS_TAB_BAR_INDEX];
    return (SSRecentPhotoListViewController*)recentsNav.topViewController;
}

- (void) setShowMasterButtonForAllChildren:(UIBarButtonItem*)button
{
    // Get nav controller and all its children (including self)
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if ([vc respondsToSelector:@selector(setShowListsButton:)]) {
            [vc performSelector:@selector(setShowListsButton:) withObject:button];
        }
    }
}
                    


@end
