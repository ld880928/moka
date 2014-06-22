//
//  MOKADetailView.h
//  linker
//
//  Created by 李迪 on 14-6-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOKADetailView : UIView

@property(nonatomic,copy)void(^gotoDetailBlock)();
@property(nonatomic,copy)void(^backBlock)();

+ (instancetype)MOKADetailViewWithData:(id)data_;

@end
