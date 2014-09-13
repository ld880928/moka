//
//  RefundProcessViewController.m
//  linker
//
//  Created by 李迪 on 14-6-21.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "RefundProcessViewController.h"
#import "BusinessWindow.h"

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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    NSString *userName = [[AccountAndLocationManager sharedAccountAndLocationManager] userName];
    
    NSLog(@"%@",URL_SUB_REFUNDERLIST);
    
    [manager POST:URL_SUB_REFUNDERLIST parameters:@{@"username": userName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.refunderData = responseObject;
        [self.infoTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.refunderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"RefundProcessCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
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
