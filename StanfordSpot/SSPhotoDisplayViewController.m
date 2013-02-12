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

- (void) scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.hasBeenZoomed = YES;
}

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.scrollView.zoomScale = 1.0f;
        }
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
    if (self.showMasterButton) {
        NSMutableArray* mutToolBarItems = [self.toolbar.items mutableCopy];
        [mutToolBarItems insertObject:self.showMasterButton atIndex:0];
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
    CGFloat smallerZoomFactor = MAX(widthZoomFactor, heightZoomFactor);
    CGFloat biggerZoomFactor = MIN(widthZoomFactor, heightZoomFactor);
    //If the photo is too big, zoom out down to have the smaller dimension fit on screen
    if (smallerZoomFactor < 1.0f) {
        return smallerZoomFactor > self.scrollView.minimumZoomScale ? smallerZoomFactor : self.scrollView.minimumZoomScale;
    } // If the photo is too small, zoom in to eliminate white space
    else if (biggerZoomFactor > 1.0f) {
        return biggerZoomFactor < self.scrollView.maximumZoomScale ? biggerZoomFactor : self.scrollView.maximumZoomScale;
    }
    return self.scrollView.zoomScale;
}

@end
