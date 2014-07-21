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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"BusinessDetailViewTopContainerCell";
    BusinessDetailViewTopContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessDetailViewTopContainerCell" owner:self options:nil] lastObject];
    }
    
    cell.labelTitle.text = @"仟吉西饼(站前街餐厅)";
    
    cell.labelContent.text = @"地址:北京市东城区北京站出站口西侧";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //mapview
    if (!self.locationMapView) {
        self.locationMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 220.0f)];
        [self insertSubview:self.locationMapView belowSubview:self.locationTableView];
        self.locationMapView.delegate = self;
        self.locationMapView.showsUserLocation = YES;
    }
    
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
    [UIView commitAnimations];
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
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
    [UIView commitAnimations];

}
@end
