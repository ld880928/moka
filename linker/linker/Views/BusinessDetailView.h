//
//  BusinessDetailView.h
//  linker
//
//  Created by 李迪 on 14-5-24.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessDetailView : UIView

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;

+ (BusinessDetailView *)businessDetailViewWithDatas:(id)datas_;

@property(nonatomic,copy)void(^confirmPaymentBlock)();
@property(nonatomic,copy)void(^cancleBlock)();
@property(nonatomic,copy)void(^showShopTableViewBlock)();
@property(nonatomic,copy)void(^hideShopTableViewBlock)();
@property(nonatomic,copy)void(^addContactBlock)();

@end
