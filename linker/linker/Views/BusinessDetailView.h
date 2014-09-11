//
//  BusinessDetailView.h
//  linker
//
//  Created by 李迪 on 14-5-24.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessDetailViewTopContainer.h"

@interface BusinessDetailView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (nonatomic,strong) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (nonatomic,strong) MCity *currentCity;

+ (BusinessDetailView *)businessDetailView;

@property(nonatomic,copy)void(^showShopTableViewBlock)();
@property(nonatomic,copy)void(^hideShopTableViewBlock)();
@property(nonatomic,copy)void(^priceChooseCallBackBlock)(id price);
@property(nonatomic,copy)void(^addContactBlock)();

@property(nonatomic,copy)void(^textViewGetFocusBlock)();

@end
