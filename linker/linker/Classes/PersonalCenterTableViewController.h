//
//  PersonalCenterTableViewController.h
//  linker
//
//  Created by 李迪 on 14-6-5.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    PersonalCenterType_Recived_MOKA=0,
    PersonalCenterType_Sended_MOKA,
    PersonalCenterType_Refund_Process,
    PersonalCenterType_Change_Password,
    PersonalCenterType_Logout
}PersonalCenterType;

@interface PersonalCenterTableViewController : UITableViewController
@property(nonatomic,copy) void (^selectdPersonalCenterType)(PersonalCenterType personalCenterType);
@end
