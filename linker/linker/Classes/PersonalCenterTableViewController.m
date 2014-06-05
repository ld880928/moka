//
//  PersonalCenterTableViewController.m
//  linker
//
//  Created by 李迪 on 14-6-5.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "PersonalCenterTableViewController.h"

@interface PersonalCenterTableViewController ()

@end

@implementation PersonalCenterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            self.selectdPersonalCenterType(PersonalCenterType_Recived_MOKA);
            break;
        case 1:
            self.selectdPersonalCenterType(PersonalCenterType_Sended_MOKA);
            break;
        case 2:
            self.selectdPersonalCenterType(PersonalCenterType_Refund_Process);
            break;
        case 3:
            self.selectdPersonalCenterType(PersonalCenterType_Change_Password);
            break;
        case 4:
            self.selectdPersonalCenterType(PersonalCenterType_Logout);
            break;
        default:
            break;
    }
}

@end
