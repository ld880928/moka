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
#import <AddressBook/AddressBook.h>
#import "ChooseContactViewController.h"
#import "PaySucessViewController.h"

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
        safe_self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",safe_self.selectedPrice];
        
    };
    
    self.businessDetailView.textViewGetFocusBlock = ^{
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:safe_self action:@selector(hideKeyboard)];
        [safe_self.view addGestureRecognizer:ges];
        
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

        //检查信息是否正确，完全
        if (self.selectedPrice) {
            if ([self.selectedPrice isKindOfClass:[NSNumber class]]) {
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
        
        
        NSString *receiverName = @"lidi";
        NSString *receiverPhone = @"111111";
        NSString *message = @"Happy Birthday!";
        
        NSDictionary *para = @{@"user_id": userID,@"merchant_id":merchantID,@"price":price,@"receiver_name":receiverName,@"receiver_phone":receiverPhone,@"message":message};
        
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
                order.productName = @"商品标题测试"; //商品标题
                order.productDescription = @"商品描述测试"; //商品描述
                order.amount = [NSString stringWithFormat:@"%.2f",.01f]; //商品价格
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
        
        [safe_self readAllPeoples];
        
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide) name: UIKeyboardDidHideNotification object:nil];

}

- (void)keyboardWillShow
{
    self.containerScorllView.contentSize = CGSizeMake(self.containerScorllView.contentSize.width, self.containerScorllView.contentSize.height + 128.0f);
}

- (void)keyboardWillHide
{
    self.containerScorllView.contentSize = CGSizeMake(self.containerScorllView.contentSize.width, self.containerScorllView.contentSize.height - 128.0f);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaySuccessNotification object:nil];
}

-(void)readAllPeoples
{
    
    //取得本地通信录名柄
    
    ABAddressBookRef tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
    });
        
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    //取得本地所有联系人记录
    
    
    if (tmpAddressBook==nil) {
        return ;
    };
    
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    
    NSMutableArray *contacts = [NSMutableArray array];
    
    for(id tmpPerson in tmpPeoples)
        
    {
        
        //获取的联系人单一属性:First name
        
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        
        NSLog(@"First name:%@", tmpFirstName);
        
        //获取的联系人单一属性:Last name
        
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        
        NSLog(@"Last name:%@", tmpLastName);
        
        //获取的联系人单一属性:Nickname
        
        NSString* tmpNickname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNicknameProperty);
        
        NSLog(@"Nickname:%@", tmpNickname);
        
        //获取的联系人单一属性:Company name
        
        NSString* tmpCompanyname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty);
        
        NSLog(@"Company name:%@", tmpCompanyname);
        
        //获取的联系人单一属性:Job Title
        
        NSString* tmpJobTitle= (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonJobTitleProperty);
        
        NSLog(@"Job Title:%@", tmpJobTitle);
        
        
        //获取的联系人单一属性:Department name
        
        NSString* tmpDepartmentName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonDepartmentProperty);
        
        NSLog(@"Department name:%@", tmpDepartmentName);
        
        //获取的联系人单一属性:Email(s)
        
        ABMultiValueRef tmpEmails = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonEmailProperty);
        
        for(NSInteger j = 0; ABMultiValueGetCount(tmpEmails); j++)
            
        {
            
            NSString* tmpEmailIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpEmails, j);
            
            NSLog(@"Emails%d:%@", j, tmpEmailIndex);
            
        }
        
        CFRelease(tmpEmails);
        
        //获取的联系人单一属性:Birthday
        
        NSDate* tmpBirthday = (__bridge NSDate*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonBirthdayProperty);
        
        NSLog(@"Birthday:%@", tmpBirthday);
        
        //获取的联系人单一属性:Note
        
        NSString* tmpNote = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNoteProperty);
        
        NSLog(@"Note:%@", tmpNote);
        
        //获取的联系人单一属性:Generic phone number
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        
        NSString *phone = @"";
        
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
            
        {
            
            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            
            NSLog(@"tmpPhoneIndex%d:%@", j, tmpPhoneIndex);
            
            phone = tmpPhoneIndex;
            
        }
        
        [contacts addObject:@{@"name": [NSString stringWithFormat:@"%@%@",tmpFirstName,tmpLastName],@"phone":phone}];
        
        
        CFRelease(tmpPhones);
        
    }
    
    //释放内存
    
    CFRelease(tmpAddressBook);
    
    [self performSegueWithIdentifier:@"ChooseContactViewControllerSegue" sender:contacts];
}

- (void)hideKeyboard
{
    [self.businessDetailView.textViewMessage resignFirstResponder];
    
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
        destinationViewController.contacts = sender;
        destinationViewController.chooseSuccessBlock = ^(NSDictionary *contact){
            self.businessDetailView.labelName.text = [contact objectForKey:@"name"];
            
        };
    }
    
    if ([segue.identifier isEqualToString:@"PaySucessViewControllerSegue"]) {
        PaySucessViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.currentCity = self.currentCity;
        destinationViewController.mMerchant = self.mMerchant;
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
