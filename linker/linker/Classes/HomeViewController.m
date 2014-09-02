//
//  HomeViewController.m
//  linker
//
//  Created by 李迪 on 14-5-13.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "HomeViewController.h"
#import "BusinessWindow.h"
#import "ChooseCityViewController.h"
#import "LoginViewController.h"
#import "PersonalCenterContainerWindow.h"
#import "LightStateBarNavigationController.h"
#import "BusinessesViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *navigationTableView;
@property (nonatomic,strong) NSMutableArray *navigationData;

@property (nonatomic,strong)UIButton *locationBtn;
@property (nonatomic,strong)MCity *currentCity;

@end

@implementation HomeViewController
{
    CGAffineTransform keyWindowTransform;
}

- (IBAction)gotoMyCenter:(id)sender
{
    //判断是否登录
    if ([[AccountAndLocationManager sharedAccountAndLocationManager] loginSuccess])
    {
        [self performSegueWithIdentifier:@"PersonalCenterViewController" sender:self];
    }
    else
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        LightStateBarNavigationController *navController = [[LightStateBarNavigationController alloc] initWithRootViewController:viewController];
        PersonalCenterContainerWindow *containerWindow = [[PersonalCenterContainerWindow alloc] initWithRootViewController:navController];
        viewController.loginSuccessBlock = ^{
            [containerWindow disAppear];
        };
        [containerWindow showWithStautsBar:YES];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentCity = [[AccountAndLocationManager sharedAccountAndLocationManager] currentSelectedCity];
    self.navigationData = [[DataBaseManager sharedManager] getCategorysByCity:self.currentCity];
    [self.navigationTableView reloadData];

    keyWindowTransform = [[[UIApplication sharedApplication] delegate] window].transform;
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage createImageWithColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
    
    self.navigationTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.navigationTableView.backgroundColor = [UIColor clearColor];
    self.navigationTableView.backgroundView = nil;
    
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    
    [self.locationBtn setTitle:self.currentCity.f_city_name forState:UIControlStateNormal];
    self.locationBtn.frame = CGRectMake(0, 0, 60, 44);
    
    [self.locationBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChooseCityViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"ChooseCityViewController"];
        PersonalCenterContainerWindow *containerWindow = [[PersonalCenterContainerWindow alloc] initWithRootViewController:viewController];
        
        [viewController setChooseCityConmpleteBlock:^(MCity *city) {
            
            if (![city.f_city_id isEqualToString:self.currentCity.f_city_id]) {
                
                self.currentCity = city;
                [self.locationBtn setTitle:self.currentCity.f_city_name forState:UIControlStateNormal];
                [self refreshDataWithCity:city];
                
            }
            else
            {
                [[BusinessWindow sharedBusinessWindow] moveToBottom];
            }
            
        }];

        viewController.callWindowBackBlock = ^{
            [containerWindow disAppear];
        };
        
        [containerWindow showWithStautsBar:YES];
        
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.locationBtn];
    
    [self performSelector:@selector(viewHasLoaded) withObject:self afterDelay:.1f];
}

- (void)viewHasLoaded
{
    BusinessWindow *businessWindow = [BusinessWindow sharedBusinessWindow];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BusinessesViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"BusinessesViewController"];
    
    businessWindow.refreshMerchant = ^(MCity *city , MCategory *category_){
        
        [viewController refreshDataWithCityID:city category:category_];
        
    };
    
    businessWindow.rootViewController = viewController;
    [businessWindow show];
    
    [businessWindow setPositionYChangedCallBackBlock:^(CGFloat percent) {
        //CGAffineTransform transform = CGAffineTransformScale(keyWindowTransform, percent, percent);
        //[[[UIApplication sharedApplication] delegate] window].transform = transform;
    }];
    
    if (self.navigationData && self.navigationData.count) {
        [self tableView:self.navigationTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    //刷新数据
    MCity *currentSelectedCity = [[AccountAndLocationManager sharedAccountAndLocationManager] currentSelectedCity];

    [self refreshDataWithCity:currentSelectedCity];
    
    //列表的数据刷新完成以后，选中推荐，window滑上去，刷新推荐商家列表
    [[BusinessWindow sharedBusinessWindow] resetPositionY:0];
    [[BusinessWindow sharedBusinessWindow] performSelector:@selector(moveToBottom) withObject:self afterDelay:3.0f];
}

- (void)refreshDataWithCity:(MCity *)city_
{
    //先刷新列表的数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    [manager POST:URL_SUB_GETCATEGORY parameters:city_.f_city_id success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *categorys = [NSMutableArray array];
        for (int i=0; i<[responseObject count]; i++) {
            MCategory *mCategory = [[MCategory alloc] initWithDictionary:[responseObject objectAtIndex:i]];
            [categorys addObject:mCategory];
        }
        
        [[DataBaseManager sharedManager] insertCategorys:categorys city:city_];
        
        self.navigationData = [[DataBaseManager sharedManager] getCategorysByCity:self.currentCity];
        
        [self.navigationTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}

#pragma mark tableview delegate  datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.navigationData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"navigation_cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 45.0f, 290.0f, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.alpha = .2f;
        [cell.contentView addSubview:lineView];
    }
    
    MCategory *category = [self.navigationData objectAtIndex:indexPath.row];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 30.0f, 30.0f)];
    [iconImageView setImageWithURL:category.f_category_icon];
    [cell.contentView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 10.0f, 200.0f, 29.0f)];
    titleLabel.text = category.f_category_name;
    titleLabel.textColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:titleLabel];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[BusinessWindow sharedBusinessWindow] moveToTop];
    
    MCategory *category = [self.navigationData objectAtIndex:indexPath.row];
    
    if ([[BusinessWindow sharedBusinessWindow] refreshMerchant]) {
        [BusinessWindow sharedBusinessWindow].refreshMerchant(self.currentCity,category);
    }
}

@end
