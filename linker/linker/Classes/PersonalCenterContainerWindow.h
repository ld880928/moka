//
//  PersonalCenterContainerWindow.h
//  linker
//
//  Created by 李迪 on 14-6-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterContainerWindow : UIWindow

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController_;

- (void)showWithStautsBar:(BOOL)showStautsBar;
- (void)disAppear;

@end
