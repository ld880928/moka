//
//  RefundProcessViewController.m
//  linker
//
//  Created by 李迪 on 14-6-21.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "RefundProcessViewController.h"
#import "BusinessWindow.h"
#import "RefundProcessCell.h"

@interface RefundProcessViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (nonatomic,strong)NSArray *refunderData;
@end

@implementation RefundProcessViewController

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [[BusinessWindow sharedBusinessWindow] hideToShow];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
    
    // Do any additional setup after loading the view.
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeGradient inView:self.view];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    NSString *userName = [[AccountAndLocationManager sharedAccountAndLocationManager] userName];
    
    NSLog(@"%@",URL_SUB_REFUNDERLIST);
    
    [manager POST:URL_SUB_REFUNDERLIST parameters:@{@"username": userName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.refunderData = responseObject;
        [self.infoTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络异常"];

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.refunderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"RefundProcessCell";
    RefundProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    NSDictionary *item = [self.refunderData objectAtIndex:indexPath.row];
    
    cell.labelID.text = [item objectForKey:@"order_number"];
    cell.labelPrice.text = [item objectForKey:@"total_price"];
    
    NSString *time = [item objectForKey:@"datetime"];
    if (!time || [time isEqual:[NSNull null]] || time.length < 10) {
        cell.labelTime.text = @"";
    }
    else
    {
        cell.labelTime.text = [NSString stringWithFormat:@"您在 %@ 有一笔退款",[time substringToIndex:10]];
    }
    
    NSString *status = [item objectForKey:@"order_status"];
    
    if (!status || [status isEqual:[NSNull null]] || !status.length) {
        cell.labelStatus.text = @"";
    }
    else if([status isEqualToString:@"refunded"]){
        cell.labelStatus.text = @"已退款";

    }else if ([status isEqualToString:@"request_refunding"]){
        cell.labelStatus.text = @"申请退款";

    }else if ([status isEqualToString:@"timeout_refunding"]){
        cell.labelStatus.text = @"超时退款";

    }else
    {
        cell.labelStatus.text = @"";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0f;
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
