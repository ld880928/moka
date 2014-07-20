//
//  BusinessWindow.m
//  linker
//
//  Created by 李迪 on 14-5-23.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessWindow.h"
#import "POP/POP.h"

#define DISTANCE_BOTTOM 70.0f

@implementation BusinessWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.windowLevel = UIWindowLevelStatusBar + 1;
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self addObserver:self forKeyPath:@"businessWindowState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
    [self removeObserver:self forKeyPath:@"businessWindowState"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"frame"])
    {
        CGFloat percent = .9f + 0.1 * self.frame.origin.y / ([UIScreen mainScreen].bounds.size.height - DISTANCE_BOTTOM);
        percent = self.frame.origin.y > self.frame.size.height - DISTANCE_BOTTOM ? 1.0f : percent;
        if (self.positionYChangedCallBackBlock) {
            self.positionYChangedCallBackBlock(percent);
        }
    }
    if ([keyPath isEqualToString:@"businessWindowState"]) {
        BusinessWindowState newState = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        BusinessWindowState oldState = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
        if (newState != oldState) {
            switch (newState) {
                case BusinessWindowState_Hide:
                case BusinessWindowState_Moving:
                    //self.backgroundColor = [UIColor clearColor];
                    break;
                case BusinessWindowState_Show:
                    //self.backgroundColor = [UIColor whiteColor];
                    break;
                default:
                    break;
            }
        }
        
    }
}

+ (BusinessWindow *)sharedBusinessWindow
{
    static BusinessWindow *sharedBusinessWindowInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedBusinessWindowInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        sharedBusinessWindowInstance.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height ,sharedBusinessWindowInstance.bounds.size.width, sharedBusinessWindowInstance.bounds.size.height);
        sharedBusinessWindowInstance.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
        sharedBusinessWindowInstance.layer.shadowRadius = 10.0f;
        sharedBusinessWindowInstance.layer.shadowOpacity = 1.0f;
        sharedBusinessWindowInstance.layer.shadowColor = [UIColor blackColor].CGColor;
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
    POPSpringAnimation *animationToTop = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    animationToTop.toValue = [NSValue valueWithCGRect:CGRectMake(self.frame.origin.x,
                                                                 0,
                                                                 self.bounds.size.width,
                                                                 self.bounds.size.height)];
    
    [animationToTop setCompletionBlock:^(POPAnimation *popAnimation, BOOL finished) {
        self.businessWindowState = BusinessWindowState_Show;
        if (self.gotoTopFinishedCallBackBlock) {
            self.gotoTopFinishedCallBackBlock(finished);
        }

    }];
    animationToTop.springBounciness = 1.0f;
    animationToTop.springSpeed = 6.0f;
    [self pop_addAnimation:animationToTop forKey:@"animation_top"];
}

- (void)moveToBottom
{
    POPSpringAnimation *animationToBottom = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    animationToBottom.toValue = [NSValue valueWithCGRect:CGRectMake(self.frame.origin.x,
                                                                    [UIScreen mainScreen].bounds.size.height - DISTANCE_BOTTOM,
                                                                    self.bounds.size.width,
                                                                    self.bounds.size.height)];
    
    [animationToBottom setCompletionBlock:^(POPAnimation *popAnimation, BOOL finished) {
        self.businessWindowState = BusinessWindowState_Hide;
        if (self.gotoBottomFinishedCallBackBlock) {
            self.gotoBottomFinishedCallBackBlock(finished);
        }
    }];
    animationToBottom.springBounciness = 9.0f;
    animationToBottom.springSpeed = 6.0f;
    [self pop_addAnimation:animationToBottom forKey:@"animation_bottom"];
}

@end
