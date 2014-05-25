//
//  BusinessView.h
//  linker
//
//  Created by 李迪 on 14-5-25.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessView : UIView
+ (BusinessView *)businessViewWithDatas:(id)datas_;

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonDetail;

@property(nonatomic,copy)void(^gotoDetailBlock)();

- (IBAction)gotoDetail:(id)sender;

@end
