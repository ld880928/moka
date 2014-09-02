//
//  BusinessDetailViewTopContainer.h
//  linker
//
//  Created by jijeMac2 on 14-5-30.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface BusinessDetailViewTopContainer : UIView
+ (BusinessDetailViewTopContainer *)businessDetailViewTopContainer;

@property(nonatomic,strong)NSArray *storesArray;
@property(nonatomic,strong)UITableView *locationTableView;
@property(nonatomic,strong)BMKMapView *locationMapView;

@property(nonatomic,copy)void(^mapViewShowOrHideCallBackBlock)(BOOL hide);

- (void)backToTableView;
@end
