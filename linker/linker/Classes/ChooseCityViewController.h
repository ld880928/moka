//
//  ChooseCityViewController.h
//  linker
//
//  Created by 李迪 on 14-5-25.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallWindowBackViewController.h"

@interface ChooseCityViewController : CallWindowBackViewController
@property(nonatomic,copy)void(^chooseCityConmpleteBlock)(NSString *cityName);
@end
