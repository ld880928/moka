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
#import "ChooseContactViewController.h"
#import "PaySucessViewController.h"
#import <AddressBook/AddressBook.h>

#import "AlixLibService.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "PartnerConfig.h"

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
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;

@property (strong,nonatomic)id selectedPrice;
@property (strong,nonatomic)NSDictionary *selectedContact;
@end

@implementation BusinessDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.imageViewBackground setImageWithURL:self.mMerchant.f_merchant_background_image];
    
    self.containerScorllView.layer.cornerRadius = 10.0f;
    
    __unsafe_unretained BusinessDetailViewController *safe_self = self;
    
    self.businessDetailView = [BusinessDetailView businessDetailView];
    self.businessDetailView.priceChooseCallBackBlock = ^(id price){
        
        safe_self.selectedPrice = price;
        
        if ([price isKindOfClass:[NSDictionary class]]) {
            safe_self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",[safe_self.selectedPrice objectForKey:@"price"]];

        }
        else
        safe_self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",safe_self.selectedPrice];
        
    };
    
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

    //支付
    [self.buttonConfirmPay handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        NSString *userID = [[AccountAndLocationManager sharedAccountAndLocationManager] userID];
        NSString *merchantID = self.mMerchant.f_merchant_id;
        
        NSNumber *price = @.01;

        NSString *combo_id = @"-1";
        //检查信息是否正确，完全
        if (self.selectedPrice) {
            if ([self.selectedPrice isKindOfClass:[NSDictionary class]]) {
                
                combo_id = [self.selectedPrice objectForKey:@"combo_id"];
                price = [NSNumber numberWithDouble:[[self.selectedPrice objectForKey:@"price"] doubleValue]];
            }
            else if ([self.selectedPrice isKindOfClass:[NSNumber class]]) {
                price = self.selectedPrice;
                
                if (price.doubleValue == 0) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    return;
                }
                
            }
            else if([self.selectedPrice isKindOfClass:[NSString class]])
            {
                if ([self.selectedPrice length]) {
                    
                    if ([self isPureInt:self.selectedPrice] || [self isPureFloat:self.selectedPrice]) {
                        price = [NSNumber numberWithDouble:[self.selectedPrice doubleValue]];
                        if (price.doubleValue == 0) {
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                            
                            return;
                        }
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        
                        return;
                    }
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    return;
                }
            }
        }
        else
        {
            //未选择金额
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        if (self.selectedContact) {
            if ([self.selectedContact objectForKey:@"phone"] && [[self.selectedContact objectForKey:@"phone"] length]) {
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择联系人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return;
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择联系人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        NSString *receiverName = [self.selectedContact objectForKey:@"name"];
        NSString *receiverPhone = [self.selectedContact objectForKey:@"phone"];;
        NSString *message = self.businessDetailView.textViewMessage.text;
        
        NSDictionary *para = @{@"user_id": userID,@"merchant_id":merchantID,@"price":price,@"combo_id": combo_id ,@"receiver_name":receiverName,@"receiver_phone":receiverPhone,@"message":message};
        
        //生成订单
        //验证用户名密码，成功后退出登录界面
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
        
        [SVProgressHUD showWithStatus:@"正在生成订单" maskType:SVProgressHUDMaskTypeGradient];
        
        [manager POST:URL_SUB_CREATEORDER parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            int resCode = [[responseObject objectForKey:@"status"] intValue];
            
            if (!resCode) {
                
                [SVProgressHUD showSuccessWithStatus:@"生成订单成功"];
                
                NSString *orderID = [responseObject objectForKey:@"order_id"];
                
                 //点击获取prodcut实例并初始化订单信息
                AlixPayOrder *order = [[AlixPayOrder alloc] init];
                order.partner = PartnerID;
                order.seller = SellerID;
                
                order.tradeNO = orderID;
                order.productName = @"摩卡"; //商品标题
                order.productDescription = @"商品描述测试"; //商品描述
                order.amount = [NSString stringWithFormat:@"%@",price]; //商品价格
                order.notifyURL =  Notif_URL; //回调URL
                
                NSString *orderInfo = [order description];
                NSString *signedStr = [self doRsa:orderInfo];

                //NSLog(@"%@",signedStr);
                
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                         orderInfo, signedStr, @"RSA"];
                
                [AlixLibService payOrder:orderString AndScheme:APPScheme seletor:@selector(paymentResult:) target:self];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"生成订单失败"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"生成订单失败"];
        }];
        
        
        
    }];
    
    //注册消息，接受支付完成的订单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:kPaySuccessNotification object:nil];
    
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
        ABAddressBookRef tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [safe_self performSegueWithIdentifier:@"ChooseContactViewControllerSegue" sender:nil];
            });
            
        });
    }];
    
    [self.containerScorllView addSubview:self.businessDetailView];
    self.containerScorllView.contentSize = self.businessDetailView.bounds.size;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    [SVProgressHUD showWithStatus:@"加载数据中" maskType:SVProgressHUDMaskTypeGradient];
    
    [manager POST:URL_SUB_GETSUPRISE parameters:@{@"merchant_id": self.mMerchant.f_merchant_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
        [safe_self.iconImageView setImageWithURL:self.mMerchant.f_merchant_logo_image];
        safe_self.merchantName.text = self.mMerchant.f_merchant_logo_name;
        
        safe_self.businessDetailView.currentCity = self.currentCity;
        safe_self.businessDetailView.data = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        
        NSLog(@"%@",error);
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardDidHideNotification object:nil];

}

- (void)keyboardWillShow:(NSNotification *)notif
{
    self.containerScorllView.contentSize = CGSizeMake(self.containerScorllView.contentSize.width, self.containerScorllView.contentSize.height + 128.0f);
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:ges];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    self.containerScorllView.contentSize = CGSizeMake(self.containerScorllView.contentSize.width, self.containerScorllView.contentSize.height - 128.0f);
    
    for (UIGestureRecognizer *ges in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:ges];
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaySuccessNotification object:nil];
}

- (void)hideKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    //[self.businessDetailView.textViewMessage resignFirstResponder];
    
    for (UIGestureRecognizer *ges in [self.view gestureRecognizers]) {
        [self.view removeGestureRecognizer:ges];
    }
}

#define mark Alipay
- (NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

- (void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotification object:result];
            
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

- (void)paySuccess:(NSNotification *)notif
{
    NSLog(@"---------------    %@",notif.object);
    
    [self performSegueWithIdentifier:@"PaySucessViewControllerSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChooseContactViewControllerSegue"]) {
        ChooseContactViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.chooseSuccessBlock = ^(NSDictionary *contact){
            self.businessDetailView.labelName.text = [contact objectForKey:@"name"];
            self.selectedContact = contact;
        };
    }
    
    if ([segue.identifier isEqualToString:@"PaySucessViewControllerSegue"]) {
        PaySucessViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.currentCity = self.currentCity;
        destinationViewController.mMerchant = self.mMerchant;
        destinationViewController.price = self.selectedPrice;
    }
    
}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end
