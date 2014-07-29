//
//  ChooseCityViewController.m
//  linker
//
//  Created by 李迪 on 14-5-25.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "ChooseCityViewController.h"

@interface ChooseCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property(nonatomic,strong)NSString *currentCity;
@property(nonatomic,strong)NSMutableArray *hotCityArray;
@end

@implementation ChooseCityViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];

    self.hotCityArray = [[[CommonDataManager alloc] init] selectAllCitys];
    
    [self.locationsTableView reloadData];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    [manager POST:URL_SUB_GETCITY parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *citys = [NSMutableArray array];
        for (int i=0; i<[responseObject count]; i++) {
            ZCity *zCity = [[ZCity alloc] initWithDictionary:[responseObject objectAtIndex:i]];
            [citys addObject:zCity];
        }
        
        [[[CommonDataManager alloc] init] insertCitys:citys];
        
        self.hotCityArray = citys;
        
        [self.locationsTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)dealloc
{
    
}

#pragma mark tableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotCityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL_ID = @"ChooseCityViewController_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }

    ZCity *zCity = [self.hotCityArray objectAtIndex:indexPath.row];
    cell.textLabel.text = zCity.cityName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCity *zCity = [self.hotCityArray objectAtIndex:indexPath.row];

    self.chooseCityConmpleteBlock(zCity);
    
    [[AccountAndLocationManager sharedAccountAndLocationManager] saveCurrentSelectedCity:zCity];

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

    return @"热门城市";

    //return [@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"] objectAtIndex:section];
}

@end
