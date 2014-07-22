//
//  CallWindowBackViewController.m
//  linker
//
//  Created by 李迪 on 14-6-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "CallWindowBackViewController.h"
#import "PersonalCenterContainerWindow.h"

@interface CallWindowBackViewController ()

@end

@implementation CallWindowBackViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setContainerWindow:(UIWindow *)containerWindow
{
    _containerWindow = containerWindow;
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGes];
}

- (void)handlePan:(UIPanGestureRecognizer *)ges_
{
    CGFloat distance_y = [ges_ translationInView:self.view].y;
    CGFloat businessWindow_y = self.containerWindow.frame.origin.y;
    switch (ges_.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            businessWindow_y = businessWindow_y + distance_y;
            businessWindow_y = businessWindow_y < 0 ? 0 : businessWindow_y;
            businessWindow_y = businessWindow_y > self.containerWindow.bounds.size.height ? self.containerWindow.bounds.size.height : businessWindow_y;
            self.containerWindow.frame = CGRectMake(0, businessWindow_y, self.containerWindow.bounds.size.width, self.containerWindow.bounds.size.height);
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            
            CGFloat speed_y = [ges_ velocityInView:self.view].y;
            
            if (speed_y > 200) {
                [(PersonalCenterContainerWindow *)self.containerWindow disAppear];
            }
            else if(speed_y < -1 * 200)
            {
                [(PersonalCenterContainerWindow *)self.containerWindow showWithStautsBar:NO];
            }
            else
            {
                businessWindow_y = businessWindow_y + distance_y;
                businessWindow_y = businessWindow_y < 0 ? 0 : businessWindow_y;
                businessWindow_y = businessWindow_y > self.containerWindow.bounds.size.height ? self.containerWindow.bounds.size.height : businessWindow_y;
                if (businessWindow_y < self.view.frame.size.height / 2) {
                    
                    [(PersonalCenterContainerWindow *)self.containerWindow showWithStautsBar:NO];
                }
                else
                {
                    [(PersonalCenterContainerWindow *)self.containerWindow disAppear];
                }
            }
            break;
            
        }
        default:
            break;
    }
    [ges_ setTranslation:CGPointZero inView:self.view];
    
}


@end
