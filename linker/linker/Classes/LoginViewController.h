//
//  LoginViewController.h
//  linker
//
//  Created by 李迪 on 14-6-5.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallWindowBackViewController.h"

@interface LoginViewController : UIViewController
@property(nonatomic,copy)void(^loginSuccessBlock)();
@end
