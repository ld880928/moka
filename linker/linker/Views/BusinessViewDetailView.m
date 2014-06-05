//
//  BusinessViewDetailView.m
//  linker
//
//  Created by 李迪 on 14-5-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessViewDetailView.h"
#import "BusinessView.h"

@interface BusinessViewDetailView()<UIScrollViewDelegate>

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
        UIView *detailContainer = [[UIView alloc] initWithFrame:CGRectMake(view_.detailScrollView.bounds.size.width * i,
                                                                           0,
                                                                           view_.detailScrollView.bounds.size.width,
                                                                           view_.detailScrollView.bounds.size.height)];
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 25.0f, 280.0f, 30.0f)];
        titlelabel.text = @"味觉空间的情调家";
        titlelabel.font = [UIFont boldSystemFontOfSize:20.0f];
        titlelabel.textColor = [UIColor blackColor];
        [detailContainer addSubview:titlelabel];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 60.0f, 280.0f, 55.0f)];
        descriptionLabel.text = @"将一个个看似普通的面团，经过各个工序精心的制作后，变成新鲜，时尚，健康，好吃的传递着仟吉对顾客品质至上的幸福感的载体。";
        descriptionLabel.numberOfLines = 3;
        descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
        descriptionLabel.textColor = [UIColor lightGrayColor];
        descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [detailContainer addSubview:descriptionLabel];
        
        UIImage *image_ = [UIImage imageNamed:@"detailImage"];
        UIImageView *imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 125.0f, 280.0f, 160.0f)];
        imageView_.image = image_;
        [detailContainer addSubview:imageView_];
        
        [view_.detailScrollView addSubview:detailContainer];
    }
    
    view_.detailScrollView.contentSize = CGSizeMake(view_.detailScrollView.bounds.size.width * 6, view_.detailScrollView.bounds.size.height);
    
    return view_;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.detailScrollView) {
        //解决一个拖动的冲突
        BusinessView *view_ = (BusinessView *)self.superview;
            if (view_.frame.origin.y > 0) {
                [view_ resetPositionY:0];
        }
        
        int page = floor(self.detailScrollView.contentOffset.x / self.detailScrollView.bounds.size.width);
        self.detailPageControl.currentPage = page;
    }
}

@end
