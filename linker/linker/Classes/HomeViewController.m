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

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *navigationTableView;
@property (nonatomic,strong) NSArray *navigationData;

@property (nonatomic,strong)UIButton *locationBtn;
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
        [containerWindow show];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    keyWindowTransform = [[[UIApplication sharedApplication] delegate] window].transform;
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage createImageWithColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
    
    self.navigationTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.navigationTableView.backgroundColor = [UIColor clearColor];
    self.navigationTableView.backgroundView = nil;
    
    self.navigationData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_data" ofType:@"plist"]];
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    [self.locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    NSString *currentCityName = [[AccountAndLocationManager sharedAccountAndLocationManager] currentSelectedCity];
    [self.locationBtn setTitle:currentCityName forState:UIControlStateNormal];
    self.locationBtn.frame = CGRectMake(0, 0, 60, 44);
    
    [self.locationBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChooseCityViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"ChooseCityViewController"];
        PersonalCenterContainerWindow *containerWindow = [[PersonalCenterContainerWindow alloc] initWithRootViewController:viewController];
        
        [viewController setChooseCityConmpleteBlock:^(NSString *cityName) {
            if (![cityName isEqualToString:@""]) {
                [self.locationBtn setTitle:cityName forState:UIControlStateNormal];
                if (![cityName isEqualToString:[[AccountAndLocationManager sharedAccountAndLocationManager] currentSelectedCity]]) {
                    [self refreshDataWithCityName:cityName];
                }
                else
                {
                    [[BusinessWindow sharedBusinessWindow] moveToBottom];
                }
                [[AccountAndLocationManager sharedAccountAndLocationManager] saveCurrentSelectedCity:cityName];
            }
        }];

        viewController.callWindowBackBlock = ^{
            [containerWindow disAppear];
        };
        
        [containerWindow show];
        
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.locationBtn];
    
    [self performSelector:@selector(viewHasLoaded) withObject:self afterDelay:.1f];
}

- (void)viewHasLoaded
{
    BusinessWindow *businessWindow = [BusinessWindow sharedBusinessWindow];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    businessWindow.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"BusinessesViewController"];
    businessWindow.hidden = NO;
    [businessWindow makeKeyAndVisible];
    
    [businessWindow setPositionYChangedCallBackBlock:^(CGFloat percent) {
        //CGAffineTransform transform = CGAffineTransformScale(keyWindowTransform, percent, percent);
        //[[[UIApplication sharedApplication] delegate] window].transform = transform;
    }];
    
    //检查是否有选中的城市
    NSString *currentSelectedCity = [[AccountAndLocationManager sharedAccountAndLocationManager] currentSelectedCity];
    if (!currentSelectedCity || !currentSelectedCity.length) {
        //没有选中城市，第一次安装程序.  弹出选择城市的界面
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChooseCityViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"ChooseCityViewController"];
        PersonalCenterContainerWindow *containerWindow = [[PersonalCenterContainerWindow alloc] initWithRootViewController:viewController];
        
        [viewController setChooseCityConmpleteBlock:^(NSString *cityName) {
            if (![cityName isEqualToString:@""]) {
                [self.locationBtn setTitle:cityName forState:UIControlStateNormal];
                if (![cityName isEqualToString:[[AccountAndLocationManager sharedAccountAndLocationManager] currentSelectedCity]]) {
                    [self refreshDataWithCityName:cityName];
                }
                else
                {
                    [[BusinessWindow sharedBusinessWindow] moveToBottom];
                }
                [[AccountAndLocationManager sharedAccountAndLocationManager] saveCurrentSelectedCity:cityName];
            }
        }];
        
        viewController.callWindowBackBlock = ^{
            [containerWindow disAppear];
        };
        
        [containerWindow show];
        
    }
    else
    {
        //直接刷新列表信息
        [self refreshDataWithCityName:currentSelectedCity];
    }
}

- (void)refreshDataWithCityName:(NSString *)cityName
{
    //先刷新列表的数据
    
    
    //列表的数据刷新完成以后，选中推荐，window滑上去，刷新推荐商家列表
    [[BusinessWindow sharedBusinessWindow] resetPositionY:0];
    [[BusinessWindow sharedBusinessWindow] performSelector:@selector(moveToBottom) withObject:self afterDelay:3.0f];
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
    
    NSDictionary *dataItem = [self.navigationData objectAtIndex:indexPath.row];
    
    UIImage *itemImage = [UIImage imageNamed:[dataItem objectForKey:@"iconName"]];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 10.0f, itemImage.size.width, itemImage.size.height)];
    iconImageView.image = itemImage;
    [cell.contentView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 10.0f, 50.0f, 29.0f)];
    titleLabel.text = [dataItem objectForKey:@"textName"];
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
}

@end
