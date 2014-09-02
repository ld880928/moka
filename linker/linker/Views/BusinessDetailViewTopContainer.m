//
//  BusinessDetailViewTopContainer.m
//  linker
//
//  Created by jijeMac2 on 14-5-30.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessDetailViewTopContainer.h"
#import "BusinessDetailViewTopContainerCell.h"

@interface BusinessDetailViewTopContainer()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate>

@end

@implementation BusinessDetailViewTopContainer

+ (BusinessDetailViewTopContainer *)businessDetailViewTopContainer
{
    BusinessDetailViewTopContainer *view_ = [[[NSBundle mainBundle] loadNibNamed:@"BusinessDetailViewTopContainer" owner:self options:nil] lastObject];

    //tableview
    view_.locationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 220.0f) style:UITableViewStylePlain];
    view_.locationTableView.delegate = view_;
    view_.locationTableView.dataSource = view_;
    view_.locationTableView.separatorInset = UIEdgeInsetsZero;
    
    [view_ addSubview:view_.locationTableView];
    
    return view_;
}

#pragma mark TableView DataSource And Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"BusinessDetailViewTopContainerCell";
    BusinessDetailViewTopContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessDetailViewTopContainerCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *item = [self.storesArray objectAtIndex:indexPath.row];
    /*
    address = "\U4f73\U4e3d\U5e7f\U573a\U8d1f\U4e00\U697c";
    id = 4;
    latitude = "112.00000000";
    longitude = "-36.00000000";
    name = "\U80af\U5fb7\U57fa\U4f73\U4e3d\U5e7f\U573a\U5e97";
    */
    
    cell.labelTitle.text = [item objectForKey:@"name"];
    
    cell.labelContent.text = [item objectForKey:@"address"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.storesArray objectAtIndex:indexPath.row];

    [self.locationMapView removeAnnotations:[self.locationMapView annotations]];
    
    CLLocationCoordinate2D coor;
    coor.latitude = 30.52;//[[item objectForKey:@"latitude"] doubleValue];
    coor.longitude = 114.31;// [[item objectForKey:@"longitude"] doubleValue];
    
    //mapview
    if (!self.locationMapView) {
        self.locationMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 220.0f)];
        [self insertSubview:self.locationMapView belowSubview:self.locationTableView];
        self.locationMapView.delegate = self;
    }
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coor;
    annotation.title = [item objectForKey:@"name"];
    annotation.subtitle = [item objectForKey:@"address"];
    [self.locationMapView addAnnotation:annotation];
    [self.locationMapView selectAnnotation:annotation animated:YES];//这样就可以在初始化的时候将 气泡信息弹出
    
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.05, 0.05));//越小地图显示越详细
    [self.locationMapView setRegion:region animated:YES];//执行设定显示范围
    [self.locationMapView setCenterCoordinate:coor animated:YES];//根据提供的经纬度为中心原点 以动画的形式
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:NO];
    
    NSUInteger fromIndex = [self.subviews indexOfObject:self.locationTableView];
    NSUInteger toIndex = [self.subviews indexOfObject:self.locationMapView];
    
    [self exchangeSubviewAtIndex:fromIndex withSubviewAtIndex:toIndex];
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用某个方法
    //[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    
    if (self.mapViewShowOrHideCallBackBlock) {
        self.mapViewShowOrHideCallBackBlock(NO);
    }
    
    [UIView commitAnimations];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)backToTableView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
    
    NSUInteger fromIndex = [self.subviews indexOfObject:self.locationMapView];
    NSUInteger toIndex = [self.subviews indexOfObject:self.locationTableView];
    
    [self exchangeSubviewAtIndex:fromIndex withSubviewAtIndex:toIndex];
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用某个方法
    //[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    
    if (self.mapViewShowOrHideCallBackBlock) {
        self.mapViewShowOrHideCallBackBlock(YES);
    }
    
    [UIView commitAnimations];
}

@end
