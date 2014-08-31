//
//  BusinessDetailViewController.m
//  linker
//
//  Created by 李迪 on 14-5-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "BusinessDetailView.h"
#import "UIView+Topradius.h"

#define DETAIL_HEIGHT 280.0f

@interface BusinessDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *containerScorllView;
@property(nonatomic,strong)BusinessDetailView *businessDetailView;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirmPay;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancle;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *merchantName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BusinessDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.containerScorllView.layer.cornerRadius = 10.0f;
    
    self.businessDetailView = [BusinessDetailView businessDetailView];

    __unsafe_unretained BusinessDetailViewController *safe_self = self;
    
    self.bottomView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.bottomView.layer.shadowRadius = 10.0f;
    self.bottomView.layer.shadowOpacity = 1.0f;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.buttonConfirmPay setBorderWithColor:[UIColor colorWithRed:67.0f / 255.0f green:140.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f]
                                  borderWidth:1.0f
                                 cornerRadius:5.0f];
    
    [self.buttonCancle setBorderWithColor:[UIColor colorWithRed:67.0f / 255.0f green:140.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f]
                              borderWidth:1.0f
                             cornerRadius:5.0f];

    //取消
    [self.buttonConfirmPay handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
    }];
    
    //确认支付
    [self.buttonCancle handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [self.businessDetailView setShowShopTableViewBlock:^{
        
        
        [UIView animateWithDuration:.5f animations:^{
            
            safe_self.businessDetailView.topContainerView.frame = CGRectMake(safe_self.businessDetailView.topContainerView.frame.origin.x,
                                                                             safe_self.businessDetailView.topContainerView.frame.origin.y,
                                                                             safe_self.businessDetailView.topContainerView.frame.size.width,
                                                                             DETAIL_HEIGHT);
            
            safe_self.businessDetailView.bottomContainerView.frame = CGRectMake(safe_self.businessDetailView.bottomContainerView.frame.origin.x,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.origin.y + DETAIL_HEIGHT,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.size.width,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.size.height);
        } completion:^(BOOL finished) {
            safe_self.businessDetailView.frame = CGRectMake(safe_self.businessDetailView.frame.origin.x,
                                                            safe_self.businessDetailView.frame.origin.y,
                                                            safe_self.businessDetailView.frame.size.width,
                                                            safe_self.businessDetailView.frame.size.height + DETAIL_HEIGHT);
            
            safe_self.containerScorllView.contentSize = safe_self.businessDetailView.bounds.size;
            
        }];
        
    }];
    
    [self.businessDetailView setHideShopTableViewBlock:^{
        [UIView animateWithDuration:.5f animations:^{
            
            safe_self.businessDetailView.topContainerView.frame = CGRectMake(safe_self.businessDetailView.topContainerView.frame.origin.x,
                                                                             safe_self.businessDetailView.topContainerView.frame.origin.y,
                                                                             safe_self.businessDetailView.topContainerView.frame.size.width,
                                                                             33.0f);
            
            safe_self.businessDetailView.bottomContainerView.frame = CGRectMake(safe_self.businessDetailView.bottomContainerView.frame.origin.x,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.origin.y - DETAIL_HEIGHT,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.size.width,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.size.height);
        } completion:^(BOOL finished) {
            safe_self.businessDetailView.frame = CGRectMake(safe_self.businessDetailView.frame.origin.x,
                                                            safe_self.businessDetailView.frame.origin.y,
                                                            safe_self.businessDetailView.frame.size.width,
                                                            safe_self.businessDetailView.frame.size.height - DETAIL_HEIGHT);
            safe_self.containerScorllView.contentSize = safe_self.businessDetailView.bounds.size;
            
        }];

    }];
    
    [self.businessDetailView setAddContactBlock:^{
        
    }];
    
    [self.containerScorllView addSubview:self.businessDetailView];
    self.containerScorllView.contentSize = self.businessDetailView.bounds.size;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    [SVProgressHUD showWithStatus:@"加载数据中" maskType:SVProgressHUDMaskTypeGradient];
    
    [manager POST:URL_SUB_GETSUPRISE parameters:@{@"merchant_id": self.mMerchant.f_merchant_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
        [self.iconImageView setImageWithURL:self.mMerchant.f_merchant_logo_image];
        self.merchantName.text = self.mMerchant.f_merchant_logo_name;
        
        self.businessDetailView.data = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        
        NSLog(@"%@",error);
        
    }];

    
}

@end
