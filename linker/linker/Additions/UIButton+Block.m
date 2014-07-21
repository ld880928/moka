//
//  UIButton+Block.m
//  ganqishi
//
//  Created by jijeMac2 on 14-5-13.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

static char overviewKey;

@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

- (void)setBorderWithColor:(UIColor *)color_ borderWidth:(CGFloat)width_ cornerRadius:(CGFloat)cornerRadius_
{
    self.layer.borderColor = color_.CGColor;
    self.layer.borderWidth = width_;
    self.layer.cornerRadius = cornerRadius_;
}
@end
