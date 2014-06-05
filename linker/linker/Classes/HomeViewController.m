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
    NSLog(@"%@",sender);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    keyWindowTransform = [[[UIApplication sharedApplication] delegate] window].transform;
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage createImageWithColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
    
    BusinessWindow *businessWindow = [BusinessWindow sharedBusinessWindow];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    businessWindow.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"BusinessesViewController"];
    businessWindow.hidden = NO;
    [businessWindow makeKeyAndVisible];
    
    [businessWindow setPositionYChangedCallBackBlock:^(CGFloat percent) {
        CGAffineTransform transform = CGAffineTransformScale(keyWindowTransform, percent, percent);
        [[[UIApplication sharedApplication] delegate] window].transform = transform;
    }];
    
    [businessWindow performSelector:@selector(moveToBottom) withObject:nil afterDelay:3.0f];
    
    self.navigationTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.navigationTableView.backgroundColor = [UIColor clearColor];
    self.navigationTableView.backgroundView = nil;
    
    self.navigationData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_data" ofType:@"plist"]];
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [self.locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [self.locationBtn setTitle:@" 北京" forState:UIControlStateNormal];
    self.locationBtn.frame = CGRectMake(0, 0, 60, 44);
    
    __unsafe_unretained HomeViewController *safe_self = self;
    [self.locationBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [[BusinessWindow sharedBusinessWindow] hide:YES completion:^(BOOL finished) {
            [safe_self performSegueWithIdentifier:@"ChooseCityViewController" sender:self];
        }];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.locationBtn];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationViewController = segue.destinationViewController;
    
    if ([@"businessesSegue" isEqualToString:segue.identifier]) {

    }
    if ([@"ChooseCityViewController" isEqualToString:segue.identifier]) {
        ChooseCityViewController *controller = (ChooseCityViewController *)destinationViewController;
        [controller setChooseCityConmpleteBlock:^(NSString *cityName) {
            if (![cityName isEqualToString:@""]) {
                [self.locationBtn setTitle:cityName forState:UIControlStateNormal];
            }
            [[BusinessWindow sharedBusinessWindow] moveToBottom];
        }];
    }
    
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
    }
    
    NSDictionary *dataItem = [self.navigationData objectAtIndex:indexPath.row];
    
    UIImage *itemImage = [UIImage imageNamed:[dataItem objectForKey:@"iconName"]];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, itemImage.size.width, itemImage.size.height)];
    iconImageView.image = itemImage;
    [cell.contentView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 50, 29)];
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
