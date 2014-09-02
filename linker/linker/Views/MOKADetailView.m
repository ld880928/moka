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

@end

@implementation MOKADetailView

+ (instancetype)MOKADetailViewWithData:(id)data_
{
    MMoka *moka = data_;
    
    MOKADetailView *view = [[[NSBundle mainBundle] loadNibNamed:@"MOKADetailView" owner:self options:nil] lastObject];
    
    [view.backgroundImageView setImageWithURL:moka.f_moka_background_img];
    view.qrCodeButton.layer.cornerRadius = 5.0f;
    view.buttonRefuseProcess.layer.cornerRadius = 2.0f;
    [view.buttonRefuseProcess handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"申请退款" message:@"您是否真的要将此张摩卡作退款处理？一旦确定，你的朋友将无法收到他。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        
    }];
    return view;
}

- (IBAction)gotoDetail:(id)sender
{
    if (self.gotoDetailBlock) {
        self.gotoDetailBlock();
    }
}

- (IBAction)back:(id)sender
{
    if (self.backBlock) {
        self.backBlock();
    }
}

@end
