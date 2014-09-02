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

@end

@implementation BusinessDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.imageViewBackground setImageWithURL:self.mMerchant.f_merchant_background_image];
    
    self.containerScorllView.layer.cornerRadius = 10.0f;
    
    self.businessDetailView = [BusinessDetailView businessDetailView];

    __unsafe_unretained BusinessDetailViewController *safe_self = self;
    
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

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChooseContactViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.contacts = sender;
    destinationViewController.chooseSuccessBlock = ^(NSDictionary *contact){
        
        self.businessDetailView.labelName.text = [contact objectForKey:@"name"];
        
    };
    
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


@end
