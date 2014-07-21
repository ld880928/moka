//
//  BlackStateBarNavigationController.m
//  linker
//
//  Created by colin on 14-7-21.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BlackStateBarNavigationController.h"

@interface BlackStateBarNavigationController ()

@end

@implementation BlackStateBarNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
