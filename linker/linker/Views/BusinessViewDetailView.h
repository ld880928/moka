//
//  BusinessViewDetailView.h
//  linker
//
//  Created by 李迪 on 14-5-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessViewDetailView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;

+ (BusinessViewDetailView *)businessViewDetailViewWithData:(id)data_;

- (CGFloat)getBottom_y;
@end
