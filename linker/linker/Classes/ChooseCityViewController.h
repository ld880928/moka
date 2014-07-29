//
//  ChooseCityViewController.h
//  linker
//
//  Created by 李迪 on 14-5-25.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallWindowBackViewController.h"

@interface ChooseCityViewController : UIViewController
@property(nonatomic,copy)void(^callWindowBackBlock)();

@property(nonatomic,copy)void(^chooseCityConmpleteBlock)(ZCity *city);
@end
