//
//  BusinessDetailView.m
//  linker
//
//  Created by 李迪 on 14-5-24.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessDetailView.h"

@interface BusinessDetailView()
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;

@end

@implementation BusinessDetailView

+ (BusinessDetailView *)businessDetailViewWithDatas:(id)datas_
{
    BusinessDetailView *view_ = [[[NSBundle mainBundle] loadNibNamed:@"BusinessDetailView" owner:self options:nil] lastObject];
    view_.textViewMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view_.textViewMessage.layer.borderWidth = 1.0f;
    return view_;
}

- (IBAction)cancle:(id)sender
{
    self.cancleBlock();
}

- (IBAction)confirm:(id)sender
{
    self.confirmPaymentBlock();
}

- (IBAction)showOrHideShopTableView:(id)sender
{
    if (![sender tag]) {
        self.showShopTableViewBlock();
        [sender setTag:1];
    }
    else
    {
        self.hideShopTableViewBlock();
        [sender setTag:0];
    }
}
- (IBAction)addContact:(id)sender
{
    self.addContactBlock();
}

@end
