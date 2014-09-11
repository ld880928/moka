//
//  RegisterViewController.m
//  linker
//
//  Created by 李迪 on 14-6-5.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonRegister;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPasswordConfirm;

@end

@implementation RegisterViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
	// Do any additional setup after loading the view.
    [self.buttonRegister setBorderWithColor:[UIColor colorWithRed:67.0f / 255.0f green:140.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f]
                             borderWidth:1.0f
                            cornerRadius:5.0f];
    
    [self.buttonRegister handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        [self.textFieldUsername resignFirstResponder];
        [self.textFieldPassword resignFirstResponder];
        [self.textFieldPasswordConfirm resignFirstResponder];

        //验证值的有效性
        
        if (![self.textFieldPassword.text isEqualToString:self.textFieldPasswordConfirm.text]) {
            [SVProgressHUD showErrorWithStatus:@"2次输入的密码不相同无法注册"];
            return;
        }
        
        if (!self.textFieldPassword.text || self.textFieldPassword.text.length < 6) {
            [SVProgressHUD showErrorWithStatus:@"密码长度必须大于6"];
            return;
        }
        
        NSString *userName = self.textFieldUsername.text;
        NSString *password = self.textFieldPassword.text;
        
        [SVProgressHUD showWithStatus:@"正在注册" maskType:SVProgressHUDMaskTypeGradient];

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
        
        [manager POST:URL_SUB_REGISTER parameters:@{@"username": userName,@"password":password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            int code = [[responseObject objectForKey:@"status"] intValue];
            
            if (code == 0) { //登录成功
                [[AccountAndLocationManager sharedAccountAndLocationManager] saveUserName:userName];
                [[AccountAndLocationManager sharedAccountAndLocationManager] savePassword:password];
                
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"网络连接失败"];

            NSLog(@"%@",error);
            
        }];
        
    }];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
