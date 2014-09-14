//
//  ChooseContactViewController.h
//  linker
//
//  Created by 李迪 on 14-9-14.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseContactViewController : UIViewController
@property(nonatomic,copy)void(^chooseSuccessBlock)(NSDictionary *contact);
@end
