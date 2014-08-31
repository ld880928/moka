//
//  BusinessView.m
//  linker
//
//  Created by 李迪 on 14-5-25.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessView.h"
#import "Models.h"
#import "UIImage+ImageEffects.h"

@interface BusinessView()
@property(nonatomic,assign)CGFloat bottom_y;
@end

@implementation BusinessView

- (CGFloat)getBottom_y
{
    return self.bottom_y;
}

+ (BusinessView *)businessViewWithDatas:(id)datas_
{
    MMerchant *mMerchant = datas_;
    
    BusinessView *view_ = [[[NSBundle mainBundle] loadNibNamed:@"BusinessView" owner:self options:nil] lastObject];
    view_.businessViewState = BusinessViewState_DetailHide;
    view_.labelName.text = mMerchant.f_merchant_name;
    view_.labelTitle.text = mMerchant.f_merchant_description;
    
    [view_.backgroundImageView setImageWithURL:mMerchant.f_merchant_background_image
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                         view_.backgroundMaskImageView.image = [view_.backgroundImageView.image applyBlurWithRadius:20.0f tintColor:[UIColor clearColor] saturationDeltaFactor:.5f maskImage:nil];
                                     } ];
    
    [view_.buttonDetail setBorderWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:.3f]
                               borderWidth:1.0f
                              cornerRadius:5.0f];
    view_.bottom_y = view_.bottomContainerView.frame.origin.y;
    view_.detailView = [BusinessViewDetailView businessViewDetailViewWithData:mMerchant.details];
    [view_ addSubview:view_.detailView];
    
    [view_.bottomContainerView addObserver:view_ forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

    return view_;
}

- (void)dealloc
{
    [self.bottomContainerView removeObserver:self forKeyPath:@"frame"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"frame"])
    {
        CGFloat distance = self.bounds.size.height - self.bottomContainerView.bounds.size.height;
        CGFloat percent = self.bottomContainerView.frame.origin.y / distance;
        percent = percent > 1 ? 1.0f : percent;
        self.positionYChangedCallBackBlock(percent);
        
        
        CGFloat top = 568.0f - self.detailView.bounds.size.height;
        
        self.detailView.frame = CGRectMake(self.detailView.frame.origin.x,
                                           top + self.detailView.bounds.size.height * percent,
                                           self.detailView.bounds.size.width,
                                           self.detailView.bounds.size.height);
        
        distance = self.bottom_y / 2;
        CGFloat backgroundY = distance * (percent - 1);
        self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x,
                                                    backgroundY,
                                                    self.backgroundImageView.bounds.size.width,
                                                    self.backgroundImageView.bounds.size.height);
        
        self.backgroundMaskImageView.frame = CGRectMake(self.backgroundMaskImageView.frame.origin.x,
                                                    backgroundY,
                                                    self.backgroundMaskImageView.bounds.size.width,
                                                    self.backgroundMaskImageView.bounds.size.height);
        self.backgroundMaskImageView.alpha = 1 - percent;
    }
}

- (IBAction)gotoDetail:(id)sender
{
    self.gotoDetailBlock();
}

- (void)resetPositionY:(CGFloat)positionY_
{
    self.bottomContainerView.frame = CGRectMake(self.bottomContainerView.frame.origin.x, positionY_, self.bottomContainerView.bounds.size.width, self.bottomContainerView.bounds.size.height);
}

- (void)moveToTop
{
    [UIView animateWithDuration:.5f animations:^{
        [self resetPositionY:0];
    } completion:^(BOOL finished) {
        self.businessViewState = BusinessViewState_DetailShow;
        if (self.gotoTopFinishedCallBackBlock) {
            self.gotoTopFinishedCallBackBlock(finished);
        }
    }];
}

- (void)moveToBottom
{
    [UIView animateWithDuration:.5f animations:^{
        [self resetPositionY:[self getBottom_y]];
    } completion:^(BOOL finished) {
        self.businessViewState = BusinessViewState_DetailHide;
        if (self.gotoBottomFinishedCallBackBlock) {
            self.gotoBottomFinishedCallBackBlock(finished);
        }
    }];
}
@end
