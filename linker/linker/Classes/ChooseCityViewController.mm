//
//  ChooseCityViewController.m
//  linker
//
//  Created by 李迪 on 14-5-25.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "BMapKit.h"

@interface ChooseCityViewController ()<BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property(nonatomic,strong)BMKLocationService *locationService;
@property(nonatomic,strong)NSString *currentCity;
@property(nonatomic,strong)NSArray *hotCityArray;
@end

@implementation ChooseCityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    
    self.hotCityArray = @[@"上海",@"武汉",@"广州",@"深圳",@"成都",@"重庆",@"天津",@"杭州"];
    
    //开启定位功能
    
    NSLog(@"进入普通定位态");
}

- (void)dealloc
{
    self.locationService = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationService startUserLocationService];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.locationService stopUserLocationService];
    self.locationService = nil;
    [super viewWillDisappear:animated];
}

#pragma mark tableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = self.hotCityArray.count;
            break;
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL_ID = @"ChooseCityViewController_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    if (indexPath.section == 0) {
        if (!self.currentCity || self.currentCity.length == 0) {
            cell.textLabel.text = @"定位中...";
        }
        else
        cell.textLabel.text = self.currentCity;
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = [self.hotCityArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = [self.locationsTableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if ([cityName isEqualToString:@"定位中..."]) {
        self.chooseCityConmpleteBlock(@"");
    }
    else self.chooseCityConmpleteBlock(cityName);
    
    if (self.callWindowBackBlock) {
        self.callWindowBackBlock();
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"GPS定位城市";
    }
    else if (section == 1) {
        return @"热门城市";
    }
    else
        return nil;
    
    //return [@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"] objectAtIndex:section];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	}
    
    CLGeocoder *Geocoder=[[CLGeocoder alloc]init];
    
    CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error) {
        
        for (CLPlacemark *placemark in place) {
            
            NSString *cityName = placemark.locality;
            
            self.currentCity = cityName;
            [self.locationsTableView reloadData];
            
            break;
            
        }
        
    };
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
    [Geocoder reverseGeocodeLocation:loc completionHandler:handler];
    
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@",error);
}


@end
