//
//  MOKADetailViewController.m
//  linker
//
//  Created by colin on 14-7-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MOKADetailViewController.h"
#import "MOKADetailView.h"
#import "MOKADetailMessageViewController.h"

@interface MOKADetailViewController ()<UIAlertViewDelegate>

@end

@implementation MOKADetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    MOKADetailView *detailView = [MOKADetailView MOKADetailViewWithData:self.data];
    
    [detailView setBackBlock:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [detailView setGotoDetailBlock:^(MMoka *moka){
        [self performSegueWithIdentifier:@"MOKADetailMessageViewControllerSegue" sender:moka];
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"申请退款" message:@"您是否真的要将此张摩卡作退款处理？一旦确定，你的朋友将无法收到他。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    [detailView setRefundBlock:^{
        
        [alertView show];
        
    }];
    
    detailView.frame = self.view.frame;
    self.view = detailView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [SVProgressHUD showWithStatus:@"正在申请退款..." maskType:SVProgressHUDMaskTypeGradient inView:self.view];

        //退款
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
        
        NSString *orderID = [(MMoka *)self.data f_moka_order_id];
        
        [manager POST:URL_SUB_REFUNDREQUEST parameters:@{@"order_id": orderID,@"comment":@"申请退款"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            int code = [[responseObject objectForKey:@"status"] intValue];
            if (code == 0) {
                [SVProgressHUD showSuccessWithStatus:@"申请成功"];
            }
            else
            {
                NSString *errorInfo = [responseObject objectForKey:@"info"];
                [SVProgressHUD showErrorWithStatus:errorInfo];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"网络异常"];

            
        }];
        
        
        
        NSLog(@"222");
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MOKADetailMessageViewController *controller = segue.destinationViewController;
    controller.moka = sender;
}

@end
