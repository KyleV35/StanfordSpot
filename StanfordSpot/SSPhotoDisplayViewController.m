//
//  SSPhotoDisplayViewController.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/8/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSPhotoDisplayViewController.h"

@interface SSPhotoDisplayViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic) BOOL hasBeenZoomed;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end

@implementation SSPhotoDisplayViewController

#pragma mark Lazy Instantiation

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (void) setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    // User manually zoomed
    self.hasBeenZoomed = YES;
}

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        NSURL* imageURL = self.imageURL;
        dispatch_queue_t downloadQueue = dispatch_queue_create("Photo Download", NULL);
        [self.spinner startAnimating];
        dispatch_async(downloadQueue, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
            
            //UIImage is thread safe, okay to do here
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            //Check to make sure the user is still waiting for the image to download
            if (imageURL == self.imageURL) {
                
                // Dispatch to main thread to do UIKit work
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        self.scrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                        self.scrollView.zoomScale = [self autoCalculateZoomValue];
                    }
                    [self.spinner stopAnimating];
                });
            }
        });
        
    }
    [self.titleBarButtonItem setTitle:self.title];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void) setUp
{
    self.hasBeenZoomed = NO;
	[self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self placeShowMasterButtonOnToolbar];
    [self resetImage];
}

- (void) placeShowMasterButtonOnToolbar
{
    if (self.showListsButton) {
        NSMutableArray* mutToolBarItems = [self.toolbar.items mutableCopy];
        [mutToolBarItems insertObject:self.showListsButton atIndex:0];
        self.toolbar.items = mutToolBarItems;
    }
}

- (void) viewDidLayoutSubviews
{
    // Only autozoom if the user has not manually zoomed
    if (!self.hasBeenZoomed) {
        self.scrollView.zoomScale = [self autoCalculateZoomValue];
    }
}

- (CGFloat)autoCalculateZoomValue
{
    CGFloat widthZoomFactor = self.scrollView.bounds.size.width/self.imageView.bounds.size.width;
    CGFloat heightZoomFactor = self.scrollView.bounds.size.height/self.imageView.bounds.size.height;
    CGFloat biggerZoomFactor = MAX(widthZoomFactor, heightZoomFactor);
    //If the photo is too big, zoom out down to have the smaller dimension fit on screen
    if (widthZoomFactor < 1.0f && heightZoomFactor < 1.0f) {
        return biggerZoomFactor > self.scrollView.minimumZoomScale ? biggerZoomFactor : self.scrollView.minimumZoomScale;
    } // If the photo is too small, zoom in to eliminate white space
    else if (biggerZoomFactor > 1.0f) {
        return biggerZoomFactor < self.scrollView.maximumZoomScale ? biggerZoomFactor : self.scrollView.maximumZoomScale;
    }
    return self.scrollView.zoomScale;
}

-(void)setShowListsButton:(UIBarButtonItem *)showListsButton
{
    if (showListsButton) {
        _showListsButton = showListsButton;
        [self placeShowMasterButtonOnToolbar];
    } else {
        [self removeShowMasterButtonFromToolbar];
        _showListsButton = showListsButton;
    
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (!self.hasBeenZoomed) {
        self.scrollView.zoomScale = [self autoCalculateZoomValue];
    }
}

- (void) removeShowMasterButtonFromToolbar
{
    if (_showListsButton) {
        NSMutableArray* mutToolBarItems = [self.toolbar.items mutableCopy];
        [mutToolBarItems removeObject:_showListsButton];
        self.toolbar.items = mutToolBarItems;
    }
}

@end
