//
//  MOKADetailMessageViewController.m
//  linker
//
//  Created by 李迪 on 14-6-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MOKADetailMessageViewController.h"
#import "UIView+TopRadius.h"
#import "MOKADetailMessageCell.h"

@interface MOKADetailMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailMessageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelMerchantName;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackgroud;

@end

@implementation MOKADetailMessageViewController

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.detailMessageView dwMakeTopRoundCornerWithRadius:10.0f];
    
    [self.imageViewIcon setImageWithURL:self.moka.f_moka_icon];
    self.labelMerchantName.text = self.moka.f_moka_merchan_name;
    [self.imageViewBackgroud setImageWithURL:self.moka.f_moka_background_img];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return [self.moka.f_moka_can_consume_store allKeys].count;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 80.0f;
    }
    else
    {
        return 44.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 30.0f)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 21.0f)];
    switch (section) {
        case 0:
            titleLabel.text = @"来自";
            break;
        case 1:
            titleLabel.text = @"留言";
            break;
        case 2:
        {
            NSString *title = [NSString stringWithFormat:@"%@有%d家店可消费",self.moka.f_moka_place,[self.moka.f_moka_can_consume_store allKeys].count];
            titleLabel.text = title;
        }
            break;
        default:
            break;
    }
    
    [headerView addSubview:titleLabel];
    headerView.backgroundColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        static NSString *cell_id_message = @"MOKADetailMessageCell";
        MOKADetailMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id_message];
        
        NSDictionary *item = [self.moka.f_moka_can_consume_store objectForKey:[[self.moka.f_moka_can_consume_store allKeys] objectAtIndex:indexPath.row]];
        
        NSString *name = [item objectForKey:@"store_name"];
        NSString *address = [item objectForKey:@"store_address"];
        NSString *phone = [item objectForKey:@"store_contact"];
        
        cell.labelName.text = [name isEqual:[NSNull null]] ? @"" : name;
        cell.labelAddress.text = [address isEqual:[NSNull null]] ? @"" : address;
        cell.labelPhone.text = [phone isEqual:[NSNull null]] ? @"" : phone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cell_id = @"MOKADetailMessageCellDefault";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        }
        if (indexPath.section == 0) {
            cell.textLabel.text = [self.moka.f_moka_sender isEqual:[NSNull null]] ? @"" : self.moka.f_moka_sender;
        }
        else if(indexPath.section == 1)
        {
            cell.textLabel.text = [self.moka.f_moka_message isEqual:[NSNull null]] ? @"" : self.moka.f_moka_message;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}


@end
