//
//  MOKADetailView.m
//  linker
//
//  Created by 李迪 on 14-6-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MOKADetailView.h"

@interface MOKADetailView ()

@property (weak, nonatomic) IBOutlet UIButton *qrCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelMechantName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelSenderName;
@property (weak, nonatomic) IBOutlet UILabel *labelPlace;
@property (weak, nonatomic) IBOutlet UILabel *labelValidTime;

@property (weak, nonatomic) IBOutlet UILabel *labelComboName;

@property (strong,nonatomic)MMoka *moka;

@end

@implementation MOKADetailView

+ (instancetype)MOKADetailViewWithData:(id)data_
{
    MMoka *moka = data_;
    
    MOKADetailView *view;
    
    if (is__3__5__Screen) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"MOKADetailView_35" owner:self options:nil] lastObject];
    }
    else
    {
        view = [[[NSBundle mainBundle] loadNibNamed:@"MOKADetailView" owner:self options:nil] lastObject];
    }
    
    view.moka = moka;
    [view.backgroundImageView setImageWithURL:moka.f_moka_background_img];
    [view.imageViewIcon setImageWithURL:moka.f_moka_icon];
    view.labelMechantName.text = moka.f_moka_merchan_name;
    view.labelPrice.text = [NSString stringWithFormat:@"¥ %@",moka.f_moka_price];
    view.labelSenderName.text = moka.f_moka_sender;
    view.labelPlace.text = moka.f_moka_place;
    view.labelValidTime.text = [moka.f_moka_validtime isEqual:[NSNull null]] ? @"" : moka.f_moka_validtime;
    view.labelComboName.text = [moka.f_moka_combo_name isEqual:[NSNull null]] ? @"" : moka.f_moka_combo_name;
    
    [view.qrCodeButton setTitle:moka.f_moka_order_number forState:UIControlStateNormal];
    view.qrCodeButton.layer.cornerRadius = 5.0f;
    view.buttonRefuseProcess.layer.cornerRadius = 2.0f;
    [view.buttonRefuseProcess handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"申请退款" message:@"您是否真的要将此张摩卡作退款处理？一旦确定，你的朋友将无法收到他。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        
    }];
    
    if([moka.f_moka_status isEqualToString:@"refunded"])
    {
        view.imageViewStatus.image = [UIImage imageNamed:@"mokastatus_2"];
    }
    else if ([moka.f_moka_status isEqualToString:@"used"])
    {
        view.imageViewStatus.image = [UIImage imageNamed:@"mokastatus_1"];

    }
    else if ([moka.f_moka_status isEqualToString:@"timeout_refunding"])
    {
        view.imageViewStatus.image = [UIImage imageNamed:@"mokastatus_3"];

    }
    
    return view;
}

- (IBAction)gotoDetail:(id)sender
{
    if (self.gotoDetailBlock) {
        self.gotoDetailBlock(self.moka);
    }
}

- (IBAction)back:(id)sender
{
    if (self.backBlock) {
        self.backBlock();
    }
}

@end
