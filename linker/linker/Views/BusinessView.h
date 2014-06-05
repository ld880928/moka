//
//  BusinessView.h
//  linker
//
//  Created by 李迪 on 14-5-25.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessViewDetailView.h"

typedef enum {
    BusinessViewState_DetailShow = 0,
    BusinessViewState_DetailHide,
    BusinessViewState_DetailMoving
}BusinessViewState;

@interface BusinessView : UIView
+ (BusinessView *)businessViewWithDatas:(id)datas_;

@property (assign,nonatomic)BusinessViewState businessViewState;
@property(nonatomic,strong)BusinessViewDetailView *detailView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonDetail;

@property(nonatomic,copy)void(^positionYChangedCallBackBlock)(CGFloat percent);
@property(nonatomic,copy)void(^gotoTopFinishedCallBackBlock)(BOOL finished);
@property(nonatomic,copy)void(^gotoBottomFinishedCallBackBlock)(BOOL finished);

@property(nonatomic,copy)void(^gotoDetailBlock)();

- (IBAction)gotoDetail:(id)sender;

- (CGFloat)getBottom_y;
- (void)resetPositionY:(CGFloat)positionY_;
- (void)moveToTop;
- (void)moveToBottom;
@end
