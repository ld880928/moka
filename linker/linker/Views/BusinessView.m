//
//  BusinessView.m
//  linker
//
//  Created by 李迪 on 14-5-25.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessView.h"

@implementation BusinessView

+ (BusinessView *)businessViewWithDatas:(id)datas_
{
    BusinessView *view_ = [[[NSBundle mainBundle] loadNibNamed:@"BusinessView" owner:self options:nil] lastObject];
    
    view_.labelName.text = [datas_ objectForKey:@"name"];
    view_.labelTitle.text = [datas_ objectForKey:@"title"];
    view_.buttonDetail.layer.borderColor = [UIColor whiteColor].CGColor;
    view_.buttonDetail.layer.borderWidth = 1.0f;
    view_.buttonDetail.layer.cornerRadius = 5.0f;
    return view_;
}

- (IBAction)gotoDetail:(id)sender
{
    self.gotoDetailBlock();
}
@end
