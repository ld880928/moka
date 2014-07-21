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
@property (weak, nonatomic) IBOutlet UISegmentedControl *chooseMoneySegmentControl;
@property (weak, nonatomic) IBOutlet UIView *handleView;

@end

@implementation BusinessDetailView

+ (BusinessDetailView *)businessDetailViewWithDatas:(id)datas_
{
    BusinessDetailView *view_ = [[[NSBundle mainBundle] loadNibNamed:@"BusinessDetailView" owner:self options:nil] lastObject];
    view_.textViewMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view_.textViewMessage.layer.borderWidth = 1.0f;
    
    UIView *containerView = [BusinessDetailViewTopContainer businessDetailViewTopContainer];
    containerView.frame = CGRectMake(5.0f, 33.0f, containerView.bounds.size.width, containerView.bounds.size.height);
    [view_.topContainerView addSubview:containerView];

    return view_;
}

- (void)awakeFromNib
{
    [self.chooseMoneySegmentControl addTarget:self action:@selector(chooseMoney:) forControlEvents:UIControlEventValueChanged];
}

- (void)chooseMoney:(UISegmentedControl *)sender
{
    CGRect frame = self.handleView.frame;

    [self.handleView removeFromSuperview];
    
    if (sender.selectedSegmentIndex == sender.numberOfSegments - 1) {
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.layer.borderColor = [UIColor colorWithRed:.8f green:.8f blue:.8f alpha:1.0f].CGColor;
        view.layer.borderWidth = 1.0f;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,20.0f, view.bounds.size.height )];
        label.text = @"¥";
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 0, 200.0f, view.bounds.size.height)];
        textFiled.placeholder = @"请输入金额!";
        [view addSubview:textFiled];
        
        self.handleView = view;
        [self addSubview:self.handleView];
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = @"提拉米苏+芝士蛋挞+原味红豆奶茶（小）";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:11.0f];
        self.handleView = label;
        [self addSubview:self.handleView];
        
    }
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
