//
//  ChooseContactViewController.m
//  linker
//
//  Created by 李迪 on 14-9-14.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "ChooseContactViewController.h"
#import <AddressBook/AddressBook.h>
#import "ChooseContactCell.h"

@interface ChooseContactViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *contacts;
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@end

@implementation ChooseContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self readAllPeoples];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.contacts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.chooseSuccessBlock) {
        self.chooseSuccessBlock([self.contacts objectAtIndex:indexPath.row]);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"ChooseContactCell";
    ChooseContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    
    cell.labelName.text = [[self.contacts objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.labelPhone.text = [[self.contacts objectAtIndex:indexPath.row] objectForKey:@"phone"];

    return cell;
}

-(void)readAllPeoples
{
    [SVProgressHUD showWithStatus:@"加载联系人"];
    //取得本地通信录名柄
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
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
            
            if (!tmpFirstName || [tmpFirstName isEqual:[NSNull null]]) {
                tmpFirstName = @"";
            }
            
            //NSLog(@"First name:%@", tmpFirstName);
            
            //获取的联系人单一属性:Last name
            
            NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
            
            if (!tmpLastName || [tmpLastName isEqual:[NSNull null]]) {
                tmpLastName = @"";
            }
            
            //NSLog(@"Last name:%@", tmpLastName);
            
            /*
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
             */
            //获取的联系人单一属性:Generic phone number
            
            ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
            
            NSString *phone = @"";
            
            for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
                
            {
                
                NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
                
                //NSLog(@"tmpPhoneIndex%d:%@", j, tmpPhoneIndex);
                
                phone = tmpPhoneIndex;
                
                if (!phone || [phone isEqual:[NSNull null]]) {
                    phone = @"";
                }
                
            }
            
            [contacts addObject:@{@"name": [NSString stringWithFormat:@"%@%@",tmpFirstName,tmpLastName],@"phone":phone}];
            
            CFRelease(tmpPhones);
            
        }
        
        self.contacts = contacts;

        //释放内存
        
        CFRelease(tmpAddressBook);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            [self.contactTableView reloadData];
        });
        
    });
    
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
