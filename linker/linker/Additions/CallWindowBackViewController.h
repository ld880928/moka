//
//  CallWindowBackViewController.h
//  linker
//
//  Created by 李迪 on 14-6-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallWindowBackViewController : UIViewController
@property(nonatomic,copy)void (^callWindowBackBlock)();
@property(nonatomic,unsafe_unretained)UIWindow *containerWindow;
@end
