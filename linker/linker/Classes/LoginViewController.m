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
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
- (IBAction)login:(id)sender;

@end

@implementation LoginViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBarHidden = YES;
    
	// Do any additional setup after loading the view.
    [self.buttonLogin setBorderWithColor:[UIColor colorWithRed:67.0f / 255.0f green:140.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f]
                               borderWidth:1.0f
                              cornerRadius:5.0f];
    
    
    self.textFieldUserName.text = [[AccountAndLocationManager sharedAccountAndLocationManager] userName];
    self.textFieldPassword.text = [[AccountAndLocationManager sharedAccountAndLocationManager] password];
}
- (IBAction)cancle:(id)sender {
    
    [self.textFieldUserName resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];

    
    if (self.loginSuccessBlock) {
        self.loginSuccessBlock();
    }
}

- (IBAction)login:(id)sender {
    //验证用户名密码，成功后退出登录界面
    
    [[AccountAndLocationManager sharedAccountAndLocationManager] saveUserName:self.textFieldUserName.text];
    [[AccountAndLocationManager sharedAccountAndLocationManager] savePassword:self.textFieldPassword.text];
    [AccountAndLocationManager sharedAccountAndLocationManager].loginSuccess = YES;
    
    [self.textFieldUserName resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
    
    if (self.loginSuccessBlock) {
        self.loginSuccessBlock();
    }
}

@end
