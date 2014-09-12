//
//  LoginViewController.m
//  linker
//
//  Created by 李迪 on 14-6-5.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "LoginViewController.h"
#import "UMessage.h"

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
    
    [self.textFieldUserName resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
    
    //验证用户名密码，成功后退出登录界面
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    NSString *userName = self.textFieldUserName.text;
    NSString *password = self.textFieldPassword.text;

    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeGradient];
    
    [manager POST:URL_SUB_LOGIN parameters:@{@"username": userName,@"password":password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int code = [[responseObject objectForKey:@"status"] intValue];
        
        if (code == 0) { //登录成功
            
            NSString *currentUserName = [[AccountAndLocationManager sharedAccountAndLocationManager] userName];
            
            if (currentUserName && currentUserName.length) {
                
                [UMessage removeAlias:currentUserName type:kUMessageAliasTypeWeiXin response:^(id responseObject, NSError *error) {
                    
                    NSLog(@"remove %@ %@",currentUserName,responseObject);

                    [UMessage addAlias:userName type:kUMessageAliasTypeWeiXin response:^(id responseObject, NSError *error) {
                        
                        NSLog(@"add %@ %@",userName,responseObject);
                        
                    }];
                    
                }];
            }
            else
            {
                [UMessage addAlias:userName type:kUMessageAliasTypeWeiXin response:^(id responseObject, NSError *error) {
                    
                    NSLog(@"add %@ %@",userName,responseObject);
                    
                }];
            }
            
            [[AccountAndLocationManager sharedAccountAndLocationManager] saveUserID:[[responseObject objectForKey:@"info"] objectForKey:@"uid"]];
            [[AccountAndLocationManager sharedAccountAndLocationManager] saveUserName:userName];
            [[AccountAndLocationManager sharedAccountAndLocationManager] savePassword:password];
            [[AccountAndLocationManager sharedAccountAndLocationManager] saveUserKey:[[responseObject objectForKey:@"info"] objectForKey:@"key"]];
            [[AccountAndLocationManager sharedAccountAndLocationManager] saveLoginTime:[[responseObject objectForKey:@"info"] objectForKey:@"logintime"]];
            [AccountAndLocationManager sharedAccountAndLocationManager].loginSuccess = YES;
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            
            if (self.loginSuccessBlock) {
                self.loginSuccessBlock();
            }
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
        
        NSLog(@"%@",error);
        
    }];

}

@end
