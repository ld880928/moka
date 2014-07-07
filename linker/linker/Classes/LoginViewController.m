//
//  LoginViewController.m
//  linker
//
//  Created by 李迪 on 14-6-5.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
- (IBAction)login:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.textFieldUserName.text = [[AccountAndLocationManager sharedAccountAndLocationManager] userName];
    self.textFieldPassword.text = [[AccountAndLocationManager sharedAccountAndLocationManager] password];
}

- (IBAction)login:(id)sender {
    //验证用户名密码，成功后退出登录界面
    
    [[AccountAndLocationManager sharedAccountAndLocationManager] saveUserName:self.textFieldUserName.text];
    [[AccountAndLocationManager sharedAccountAndLocationManager] savePassword:self.textFieldPassword.text];
    [AccountAndLocationManager sharedAccountAndLocationManager].loginSuccess = YES;
    
    if (self.loginSuccessBlock) {
        self.loginSuccessBlock();
    }
}

@end
