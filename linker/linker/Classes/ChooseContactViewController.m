//
//  ChooseContactViewController.m
//  linker
//
//  Created by 李迪 on 14-9-14.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "ChooseContactViewController.h"
#import <AddressBook/AddressBook.h>
#import "pinyin.h"
#import "ChooseContactCell.h"

@interface ChooseContactViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *sections;
@property(nonatomic,strong)NSMutableDictionary *contacts;
@property(nonatomic,strong)NSArray *totalSections;
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@end

@implementation ChooseContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sections = [NSMutableArray array];
    self.contacts = [NSMutableDictionary dictionary];
    self.totalSections = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSString *sectionKey = [self.sections objectAtIndex:section];
    
    return [[self.contacts objectForKey:sectionKey] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sections objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.totalSections;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSInteger index_ = [self computeIndex:index];
    return index_;
    
}

 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.chooseSuccessBlock) {
        
        id person = [[self.contacts objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        self.chooseSuccessBlock(person);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"ChooseContactCell";
    ChooseContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    
    id person = [[self.contacts objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.labelName.text = [person objectForKey:@"name"];
    cell.labelPhone.text = [person objectForKey:@"phone"];

    return cell;
}

- (void)readAllPeoples
{
    
    [SVProgressHUD showWithStatus:@"加载联系人"];
    
    ABAddressBookRef tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
        
        //取得本地所有联系人记录
        
        if (tmpAddressBook==nil) {
            return ;
        };
        
        
        CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
        
        CFMutableArrayRef mresults=CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                            CFArrayGetCount(results),
                                                            results);
        //将结果按照拼音排序，将结果放入mresults数组中
        CFArraySortValues(mresults,
                          CFRangeMake(0, CFArrayGetCount(results)),
                          (CFComparatorFunction) ABPersonComparePeopleByName,
                          (void*) ABPersonGetSortOrdering());
        
        
        for (id person in (__bridge NSMutableArray *) mresults) {
            
            NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty);
            
            if (!tmpFirstName || [tmpFirstName isEqual:[NSNull null]]) {
                tmpFirstName = @"";
            }
            
            
            NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty);
            
            if (!tmpLastName || [tmpLastName isEqual:[NSNull null]]) {
                tmpLastName = @"";
            }
            
            NSString *personname = [NSString stringWithFormat:@"%@%@",tmpFirstName,tmpLastName];
            
            if (tmpFirstName.length && tmpLastName.length) {
                personname = [NSString stringWithFormat:@"%@%@",tmpLastName,tmpFirstName];
            }
            
            if (!personname.length) {
                continue;
            }
            
            
            ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
            
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
            
            //处理电话号码
            if (phone.length >10) {
                
                //去掉特殊字符
                NSMutableString *temp = [[NSMutableString alloc] initWithString:@""];
                for (int i=0; i<phone.length; i++) {
                    NSString *char_ = [phone substringWithRange:NSMakeRange(i, 1)];
                    
                    if ([char_ isEqualToString:@"+"] || [char_ isEqualToString:@"-" ] || [char_ isEqualToString:@" "]) {
                        continue;
                    }
                    else
                    {
                        [temp appendString:char_];
                    }
                    
                }
                
                phone = temp;
                
                //去掉 86
                if ([[phone substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"86"]) {
                    phone = [phone substringFromIndex:2];
                }
                
                if (![[phone substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
                    continue;
                }
                
            }
            else
            {
                continue;
            }
            
            
            char first = pinyinFirstLetter([personname characterAtIndex:0]);
            NSString *sectionName;
            if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
                if([self searchResult:personname searchText:@"曾"])
                    sectionName = @"Z";
                else if([self searchResult:personname searchText:@"解"])
                    sectionName = @"X";
                else if([self searchResult:personname searchText:@"仇"])
                    sectionName = @"Q";
                else if([self searchResult:personname searchText:@"朴"])
                    sectionName = @"P";
                else if([self searchResult:personname searchText:@"查"])
                    sectionName = @"Z";
                else if([self searchResult:personname searchText:@"能"])
                    sectionName = @"N";
                else if([self searchResult:personname searchText:@"乐"])
                    sectionName = @"Y";
                else if([self searchResult:personname searchText:@"单"])
                    sectionName = @"S";
                else
                    sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([personname characterAtIndex:0])] uppercaseString];
            }
            else {
                sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
            }
            
            if (![self.sections containsObject:sectionName]) {
                [self.sections addObject:sectionName];
            }
            
            NSMutableArray *contacts_ = [self.contacts objectForKey:sectionName];
            if (!contacts_) {
                contacts_ = [NSMutableArray array];
            }
            
            [contacts_ addObject:@{@"name": personname,@"phone":phone}];
            
            
            [self.contacts setValue:contacts_ forKey:sectionName];
            
            //NSLog(@"---    %@   -- %@",personname,sectionName);
            
        }
        
        //释放内存
        
        CFRelease(tmpAddressBook);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            [self.contactTableView reloadData];
        });
        
    });
}

- (BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}

- (NSInteger)computeIndex:(NSInteger)index
{
    
    for (int i=index; i<self.totalSections.count; i++) {
        
        NSString *title = [self.totalSections objectAtIndex:i];
        
        if ([self.sections containsObject:title]) {
            return [self.sections indexOfObject:title];
        }
        
    }
    
    return self.sections.count - 1;
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
