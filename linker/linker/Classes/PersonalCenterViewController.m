//
//  PersonalCenterViewController.m
//  linker
//
//  Created by 李迪 on 14-6-5.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterTableViewController.h"

@interface PersonalCenterViewController ()

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage createImageWithColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PersonalCenterTableViewController"]) {
        PersonalCenterTableViewController *destinationViewController = (PersonalCenterTableViewController *)[segue destinationViewController];
        destinationViewController.selectdPersonalCenterType          = ^(PersonalCenterType personalCenterType){
            switch (personalCenterType) {
                case PersonalCenterType_Recived_MOKA:       //我收到的摩卡
                {
                    
                }
                    break;
                case PersonalCenterType_Sended_MOKA:        //我送出的摩卡
                {
                    
                }
                    break;
                case PersonalCenterType_Refund_Process:     //退款处理
                {
                    
                }
                    break;
                case PersonalCenterType_Change_Password:    //修改密码
                {
                    
                }
                    break;
                case PersonalCenterType_Logout:             //退出
                {
                    [AccountAndLocationManager sharedAccountAndLocationManager].loginSuccess = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                default:
                    break;
            }
        };
    }
}

@end
