//
//  PersonalCenterContainerWindow.m
//  linker
//
//  Created by 李迪 on 14-6-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "PersonalCenterContainerWindow.h"
#import "AppDelegate.h"
#import "POP/POP.h"

@implementation PersonalCenterContainerWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController_
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    if (self=[super initWithFrame:bounds]) {
        self.frame = CGRectMake(0, bounds.size.height, bounds.size.width, bounds.size.height);
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
        self.windowLevel = UIWindowLevelStatusBar + 2;
        self.rootViewController = rootViewController_;
    }
    
    return self;
}

- (void)showWithStautsBar:(BOOL)showStautsBar
{
    [(AppDelegate *) [[UIApplication sharedApplication] delegate] setHandle:self];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    self.hidden = NO;
    [self makeKeyAndVisible];
    
    POPBasicAnimation *animationToTop = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    if (showStautsBar) {
        animationToTop.toValue = [NSValue valueWithCGRect:CGRectMake(0,
                                                                     20,
                                                                     bounds.size.width,
                                                                     bounds.size.height - 20)];
    }
    else
    {
        animationToTop.toValue = [NSValue valueWithCGRect:CGRectMake(0,
                                                                     0,
                                                                     bounds.size.width,
                                                                     bounds.size.height)];
    }
    
    [animationToTop setCompletionBlock:^(POPAnimation *popAnimation, BOOL finished) {

    }];
    animationToTop.duration = .5f;
    animationToTop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self pop_addAnimation:animationToTop forKey:@"window_animation_top"];
}

- (void)disAppear
{
    CGRect bounds = [[UIScreen mainScreen] bounds];

    POPBasicAnimation *animationToBottom = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    animationToBottom.toValue = [NSValue valueWithCGRect:CGRectMake(0,
                                                                    bounds.size.height,
                                                                    bounds.size.width,
                                                                    bounds.size.height)];
    
    [animationToBottom setCompletionBlock:^(POPAnimation *popAnimation, BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
        [(AppDelegate *) [[UIApplication sharedApplication] delegate] setHandle:nil];
    }];
    animationToBottom.duration = .5f;
    animationToBottom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self pop_addAnimation:animationToBottom forKey:@"window_animation_bottom"];

}

@end
