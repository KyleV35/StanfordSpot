//
//  SSDetailViewController.m
//  StanfordSpot
//
//  Created by Kyle Vermeer on 2/11/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SSDetailViewController.h"

@interface SSDetailViewController ()

@end

#define MASTER_VIEW_CONTROLLER_INDEX 0

@implementation SSDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    UITabBarController *tabBarController = self.viewControllers[MASTER_VIEW_CONTROLLER_INDEX];
    self.delegate = tabBarController.viewControllers[MASTER_VIEW_CONTROLLER_INDEX];
}
@end
