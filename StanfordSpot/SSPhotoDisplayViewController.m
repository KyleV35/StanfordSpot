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
    [self resetImage];
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
    //If the smaller of the zoom factors is above one, force that dimension to fit on screen
    if (smallerZoomFactor < 1.0f) {
        return smallerZoomFactor > self.scrollView.minimumZoomScale ? smallerZoomFactor : self.scrollView.minimumZoomScale;
    }
    return self.scrollView.zoomScale;
}

@end
