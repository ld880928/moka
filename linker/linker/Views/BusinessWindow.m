//
//  BusinessWindow.m
//  linker
//
//  Created by 李迪 on 14-5-23.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessWindow.h"

#define DISTANCE_BOTTOM 64.0f

@implementation BusinessWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.windowLevel = UIWindowLevelStatusBar + 1;
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"frame"])
    {
        CGFloat percent = .9f + 0.1 * self.frame.origin.y / ([UIScreen mainScreen].bounds.size.height - DISTANCE_BOTTOM);
        percent = self.frame.origin.y > self.frame.size.height - DISTANCE_BOTTOM ? 1.0f : percent;
        self.positionYChangedCallBackBlock(percent);
    }
}

+ (BusinessWindow *)sharedBusinessWindow
{
    static BusinessWindow *sharedBusinessWindowInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedBusinessWindowInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedBusinessWindowInstance;
}

- (void)resetPositionY:(CGFloat)positionY_
{
    self.frame = CGRectMake(self.frame.origin.x, positionY_, self.bounds.size.width, self.bounds.size.height);
}

- (void)hide:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (animated) {
        [UIView animateWithDuration:.2f animations:^{
            [self resetPositionY:self.bounds.size.height];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    }
    else
    {
        [self resetPositionY:self.bounds.size.height];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)moveToTop
{
    [UIView animateWithDuration:.5f animations:^{
        [self resetPositionY:0.0f];
    } completion:^(BOOL finished) {
        self.businessWindowState = BusinessWindowState_Show;
        if (self.gotoTopFinishedCallBackBlock) {
            self.gotoTopFinishedCallBackBlock(finished);
        }
    }];
}

- (void)moveToBottom
{
    [UIView animateWithDuration:.5f animations:^{
        [self resetPositionY:[UIScreen mainScreen].bounds.size.height - DISTANCE_BOTTOM];
    } completion:^(BOOL finished) {
        self.businessWindowState = BusinessWindowState_Hide;
        if (self.gotoBottomFinishedCallBackBlock) {
            self.gotoBottomFinishedCallBackBlock(finished);
        }
    }];
}

@end
