//
//  ChangePasswordViewController.m
//  linker
//
//  Created by 李迪 on 14-6-21.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "BusinessWindow.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (weak, nonatomic) IBOutlet UITextField *textFiledOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFiledNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFiledNewPasswordConfirm;

@end

@implementation ChangePasswordViewController

- (IBAction)back:(id)sender
{
    [self.textFiledOldPassword resignFirstResponder];
    [self.textFiledNewPassword resignFirstResponder];
    [self.textFiledNewPasswordConfirm resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    [[BusinessWindow sharedBusinessWindow] hideToShow];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

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
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
    
    // Do any additional setup after loading the view.
    [self.buttonConfirm setBorderWithColor:[UIColor colorWithRed:67.0f / 255.0f green:140.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f]
                             borderWidth:1.0f
                            cornerRadius:5.0f];
    [self.buttonConfirm handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        [self.textFiledOldPassword resignFirstResponder];
        [self.textFiledNewPassword resignFirstResponder];
        [self.textFiledNewPasswordConfirm resignFirstResponder];
        
        //检查输入值的有效性
        NSString *password = self.textFiledOldPassword.text;
        
        NSString *passwordNew = self.textFiledNewPassword.text;
        NSString *passwordNewConfirm = self.textFiledNewPasswordConfirm.text;
        
        if ([password isEqualToString:[[AccountAndLocationManager sharedAccountAndLocationManager] password]]) {
            if ([passwordNew isEqualToString:passwordNewConfirm]) {
                
            }
            else
            {
                //2次输入的不一致
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码输入不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return;
            }
        }
        else
        {
            //密码不对
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码输入不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
        
        [SVProgressHUD showWithStatus:@"正在修改" maskType:SVProgressHUDMaskTypeGradient];
        
        NSDictionary *para = @{@"user_id": [[AccountAndLocationManager sharedAccountAndLocationManager] userID],
                               @"logintime":[[AccountAndLocationManager sharedAccountAndLocationManager] userLoginTime],
                               @"key":[[AccountAndLocationManager sharedAccountAndLocationManager] userKey],
                               @"username":[[AccountAndLocationManager sharedAccountAndLocationManager] userName],
                               @"newpassword":passwordNew};
        
        [manager POST:URL_SUB_CHANGEPASSWORD parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            int code = [[responseObject objectForKey:@"status"] intValue];
            
            if (code == 0) { //成功
                
                //NSString *currentUserName = [[AccountAndLocationManager sharedAccountAndLocationManager] userName];
                /*
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
                */
                //[[AccountAndLocationManager sharedAccountAndLocationManager] saveUserID:[[responseObject objectForKey:@"info"] objectForKey:@"uid"]];
                [[AccountAndLocationManager sharedAccountAndLocationManager] savePassword:@""];
                //[AccountAndLocationManager sharedAccountAndLocationManager].loginSuccess = NO;
                
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                
                //[self.navigationController popViewControllerAnimated:YES];
                //[[BusinessWindow sharedBusinessWindow] hideToShow];

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
