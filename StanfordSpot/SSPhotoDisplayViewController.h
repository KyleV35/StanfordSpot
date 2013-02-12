//
//  SSPhotoDisplayViewController.h
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/8/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSPhotoDisplayViewController : UIViewController

@property (strong, nonatomic) NSURL* imageURL;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
