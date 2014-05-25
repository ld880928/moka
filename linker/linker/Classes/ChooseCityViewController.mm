//
//  ChooseCityViewController.m
//  linker
//
//  Created by 李迪 on 14-5-25.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "BMapKit.h"

@interface ChooseCityViewController ()<BMKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)NSString *currentCity;
@property(nonatomic,strong)NSArray *hotCityArray;
@end

@implementation ChooseCityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hotCityArray = @[@"上海",@"武汉",@"广州",@"深圳",@"成都",@"重庆",@"天津",@"杭州"];
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    //self.view = self.mapView;
    
    //开启定位功能
    [_mapView setShowsUserLocation:YES];
    
    NSLog(@"进入普通定位态");
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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
    [self dismissViewControllerAnimated:YES completion:^{
        if ([cityName isEqualToString:@"定位中..."]) {
            self.chooseCityConmpleteBlock(@"");
        }
        else self.chooseCityConmpleteBlock(cityName);
    }];
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

#pragma mark BMKMapViewDelegate
/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
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
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}


@end
