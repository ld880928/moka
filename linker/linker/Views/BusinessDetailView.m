//
//  BusinessDetailView.m
//  linker
//
//  Created by 李迪 on 14-5-24.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessDetailView.h"
#define TEXT_MAXLENGTH 170

@interface BusinessDetailView()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *chooseMoneySegmentControl;
@property (weak, nonatomic) IBOutlet UIView *handleView;
@property (weak, nonatomic) IBOutlet UIButton *btnStore;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *labelInputCount;
@end

@implementation BusinessDetailView

+ (BusinessDetailView *)businessDetailView
{
    BusinessDetailView *view_ = [[[NSBundle mainBundle] loadNibNamed:@"BusinessDetailView" owner:self options:nil] lastObject];
    view_.textViewMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view_.textViewMessage.layer.borderWidth = 1.0f;
    
    BusinessDetailViewTopContainer *containerView = [BusinessDetailViewTopContainer businessDetailViewTopContainer];
    
    [view_.btnBack handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [containerView backToTableView];
    }];
    
    containerView.mapViewShowOrHideCallBackBlock = ^ (BOOL hide)
    {
        view_.btnBack.hidden = hide;
    };
    
    containerView.frame = CGRectMake(5.0f, 33.0f, containerView.bounds.size.width, containerView.bounds.size.height);
    [view_.topContainerView addSubview:containerView];

    return view_;
}

- (void)awakeFromNib
{
    self.labelInputCount.text = [NSString stringWithFormat:@"%d / %d",0,TEXT_MAXLENGTH];
    [self.chooseMoneySegmentControl addTarget:self action:@selector(chooseMoney:) forControlEvents:UIControlEventValueChanged];
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    [self.chooseMoneySegmentControl removeAllSegments];
    
    NSArray *combos = [self.data objectForKey:@"combo"];
    
    for (int i=0; i<combos.count; i++) {
        
        NSDictionary *dic = [combos objectAtIndex:i];
        NSString *price = [NSString stringWithFormat:@"¥ %@",[dic objectForKey:@"price"]];
        
        [self.chooseMoneySegmentControl insertSegmentWithTitle:price atIndex:i animated:NO];
    }
    
    if (combos && combos.count) {
        self.chooseMoneySegmentControl.selectedSegmentIndex = 0;
        if (self.priceChooseCallBackBlock) {
            self.priceChooseCallBackBlock([[combos objectAtIndex:0] objectForKey:@"price"]);
        }
    }
    
    [self.chooseMoneySegmentControl insertSegmentWithTitle:@"其他" atIndex:combos.count animated:NO];

    self.chooseMoneySegmentControl.selectedSegmentIndex = 0;
    [self chooseMoney:self.chooseMoneySegmentControl];
    
    for (UIView *v in self.topContainerView.subviews) {
        if ([v isKindOfClass:[BusinessDetailViewTopContainer class]]) {
            
            BusinessDetailViewTopContainer *storeView = (BusinessDetailViewTopContainer *)v;
            storeView.storesArray = [self.data objectForKey:@"store"];
            [storeView.locationTableView reloadData];
            
            NSString *btnTitle = [NSString stringWithFormat:@"   %@有%d家店可消费",self.currentCity.f_city_name,storeView.storesArray.count];

            [self.btnStore setTitle:btnTitle forState:UIControlStateNormal];
            
            break;

        }
    }
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
        textFiled.returnKeyType = UIReturnKeyDone;
        textFiled.delegate = self;
        [view addSubview:textFiled];
        
        self.handleView = view;
        [self addSubview:self.handleView];
        
        if (self.priceChooseCallBackBlock) {
            self.priceChooseCallBackBlock(@0);
        }
    }
    else
    {
        NSArray *combos = [self.data objectForKey:@"combo"];
        NSDictionary *dic = [combos objectAtIndex:sender.selectedSegmentIndex];

        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = [dic objectForKey:@"name"];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:11.0f];
        self.handleView = label;
        [self addSubview:self.handleView];
        
        if (self.priceChooseCallBackBlock) {
            self.priceChooseCallBackBlock([dic objectForKey:@"price"]);
        }
        
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textViewGetFocusBlock();
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = TEXT_MAXLENGTH - [new length];
    if(res >= 0){
        
        self.labelInputCount.text = [NSString stringWithFormat:@"%d / %d",[new length],TEXT_MAXLENGTH];
        
        return YES;
    }
    else{
        NSRange rg = {0,[text length]+res};
        if (rg.length>0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.priceChooseCallBackBlock) {
        
        NSString *priceString = textField.text;
        if (range.length) {
            priceString = [priceString substringToIndex:range.location];
            if (!range.location) {
                priceString = @"0";
            }
        }
        else
        {
            priceString = [priceString stringByAppendingString:string];
        }
        
        self.priceChooseCallBackBlock(priceString);
    }
    
    return YES;
}


@end
