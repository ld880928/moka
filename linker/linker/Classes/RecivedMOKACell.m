//
//  RecivedMOKACell.m
//  linker
//
//  Created by 李迪 on 14-7-21.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "RecivedMOKACell.h"

@implementation RecivedMOKACell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setViewContent:(UIView *)viewContent
{
    NSUInteger index = [[self.contentView subviews] indexOfObject:_viewContent];
    [_viewContent removeFromSuperview];
    _viewContent = viewContent;
    [self.contentView insertSubview:_viewContent atIndex:index];
    _viewContent.userInteractionEnabled = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
