//
//  PersonalCenterViewController.m
//  linker
//
//  Created by 李迪 on 14-6-5.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterTableViewController.h"
#import "BusinessWindow.h"

@interface PersonalCenterViewController ()
@end

@implementation PersonalCenterViewController

- (IBAction)backToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage createImageWithColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 23.0f, 40.0f);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    BusinessWindow *businessWindow = [BusinessWindow sharedBusinessWindow];
    [businessWindow moveToBottom];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PersonalCenterTableViewController"]) {
        PersonalCenterTableViewController *destinationViewController = (PersonalCenterTableViewController *)[segue destinationViewController];
        destinationViewController.selectdPersonalCenterType          = ^(PersonalCenterType personalCenterType){
            switch (personalCenterType) {
                case PersonalCenterType_Recived_MOKA:       //我收到的摩卡
                {
                    [self performSegueWithIdentifier:@"RecivedMOKAViewControllerSegue" sender:self];
                    [[BusinessWindow sharedBusinessWindow] hide:YES completion:^(BOOL finished) {
                        
                    }];
                }
                    break;
                case PersonalCenterType_Sended_MOKA:        //我送出的摩卡
                {
                    [self performSegueWithIdentifier:@"SendedMOKAViewControllerSegue" sender:self];
                    [[BusinessWindow sharedBusinessWindow] hide:YES completion:^(BOOL finished) {
                        
                    }];
                }
                    break;
                case PersonalCenterType_Refund_Process:     //退款处理
                {
                    [self performSegueWithIdentifier:@"RefundProcessViewControllerSegue" sender:self];
                    [[BusinessWindow sharedBusinessWindow] hide:YES completion:^(BOOL finished) {
                        
                    }];
                }
                    break;
                case PersonalCenterType_Change_Password:    //修改密码
                {
                    [self performSegueWithIdentifier:@"ChangePasswordViewControllerSegue" sender:self];
                    [[BusinessWindow sharedBusinessWindow] hide:YES completion:^(BOOL finished) {
                        
                    }];
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
