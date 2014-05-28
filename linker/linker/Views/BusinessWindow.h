//
//  BusinessWindow.h
//  linker
//
//  Created by 李迪 on 14-5-23.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SPEED 200.0f

typedef enum {
    BusinessWindowState_Show = 0,
    BusinessWindowState_Hide,
    BusinessWindowState_Moving
}BusinessWindowState;

@interface BusinessWindow : UIWindow

@property(nonatomic,assign)BusinessWindowState businessWindowState;
@property(nonatomic,copy)void(^positionYChangedCallBackBlock)(CGFloat percent);
@property(nonatomic,copy)void(^gotoTopFinishedCallBackBlock)(BOOL finished);
@property(nonatomic,copy)void(^gotoBottomFinishedCallBackBlock)(BOOL finished);

+ (BusinessWindow *)sharedBusinessWindow;

- (void)resetPositionY:(CGFloat)positionY_;

- (void)moveToTop;

- (void)moveToBottom;

- (void)hide:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
