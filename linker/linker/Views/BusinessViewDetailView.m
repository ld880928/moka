//
//  BusinessViewDetailView.m
//  linker
//
//  Created by 李迪 on 14-5-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessViewDetailView.h"

@interface BusinessViewDetailView()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *detailPageControl;

@end

@implementation BusinessViewDetailView

- (CGFloat)getBottom_y
{
    return 568.0f;
}

+ (BusinessViewDetailView *)businessViewDetailView
{
    BusinessViewDetailView *view_ = [[[NSBundle mainBundle] loadNibNamed:@"BusinessViewDetailView" owner:self options:nil] lastObject];
    view_.frame = CGRectMake(0, [view_ getBottom_y], view_.bounds.size.width, view_.bounds.size.height);
    
    for (int i=0; i<6; i++) {
        UIImage *image_ = [UIImage imageNamed:@"detailImage"];
        UIImageView *imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(280.0f * i, 0, 280.0f, 160.0f)];
        imageView_.image = image_;
        [view_.detailScrollView addSubview:imageView_];
    }
    
    view_.detailScrollView.contentSize = CGSizeMake(280.0f * 6, 160.0f);
    
    return view_;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.detailScrollView) {
        int page = floor(self.detailScrollView.contentOffset.x / self.detailScrollView.bounds.size.width);
        self.detailPageControl.currentPage = page;
    }
}

@end
