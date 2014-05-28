//
//  UIView+TopRadius.m
//  ganqishi
//
//  Created by 李迪 on 14-5-28.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "UIView+TopRadius.h"

@implementation UIView (TopRadius)

- (void)dwMakeTopRoundCornerWithRadius:(CGFloat)radius
{
    CGSize size = self.frame.size;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, size.width - radius, 0);
    CGPathAddArc(path, NULL, size.width-radius, radius, radius,M_PI_2 ,0, NO);
    CGPathAddLineToPoint(path, NULL, size.width, size.height);
    CGPathAddLineToPoint(path, NULL, 0.0, size.width);
    CGPathAddLineToPoint(path, NULL, 0.0, radius);
    CGPathAddArc(path, NULL, radius,radius, radius, 0, -1 * M_PI_2 , NO);
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);
    self.layer.mask = shapeLayer;
}

@end
