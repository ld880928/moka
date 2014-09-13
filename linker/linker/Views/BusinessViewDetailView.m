//
//  BusinessViewDetailView.m
//  linker
//
//  Created by 李迪 on 14-5-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessViewDetailView.h"
#import "BusinessView.h"
#import "Models.h"

@interface BusinessViewDetailView()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *detailPageControl;

@end

@implementation BusinessViewDetailView

- (CGFloat)getBottom_y
{
    return KCurrentHeight;
}

+ (BusinessViewDetailView *)businessViewDetailViewWithData:(id)data_
{
    NSArray *datas = data_;
    
    BusinessViewDetailView *view_;
    
    if (is__3__5__Screen) {
        view_ = [[[NSBundle mainBundle] loadNibNamed:@"BusinessViewDetailView_35" owner:self options:nil] lastObject];
    }
    else
    {
        view_ = [[[NSBundle mainBundle] loadNibNamed:@"BusinessViewDetailView" owner:self options:nil] lastObject];
    }
    
    view_.frame = CGRectMake(0, [view_ getBottom_y], view_.bounds.size.width, view_.bounds.size.height);
    
    for (int i=0; i<datas.count; i++) {
        
        MMerchantDetail *detail = [datas objectAtIndex:i];
        
        UIView *detailContainer = [[UIView alloc] initWithFrame:CGRectMake(view_.detailScrollView.bounds.size.width * i,
                                                                           0,
                                                                           view_.detailScrollView.bounds.size.width,
                                                                           view_.detailScrollView.bounds.size.height)];
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 25.0f, 280.0f, 30.0f)];
        titlelabel.text = detail.f_merchant_detail_name;
        titlelabel.font = [UIFont systemFontOfSize:18.0f];
        titlelabel.textColor = [UIColor blackColor];
        [detailContainer addSubview:titlelabel];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 60.0f, 280.0f, 55.0f)];
        descriptionLabel.text = detail.f_merchant_detail_description;
        descriptionLabel.numberOfLines = 3;
        descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
        descriptionLabel.textColor = [UIColor lightGrayColor];
        descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [detailContainer addSubview:descriptionLabel];
        
        UIImageView *imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 125.0f, 280.0f, 160.0f)];
        [imageView_ setImageWithURL:detail.f_merchant_detail_image];
        [detailContainer addSubview:imageView_];
        
        if (is__3__5__Screen) {
            titlelabel.frame = CGRectMake(20.0f, 0, 280.0f, 30.0f);
            descriptionLabel.frame = CGRectMake(20.0f, 35.0f, 280.0f, 30.0f);
            imageView_.frame = CGRectMake(20.0f, 70.0f, 280.0f, 160.0f);
        }
        
        [view_.detailScrollView addSubview:detailContainer];
    }
    
    view_.detailScrollView.contentSize = CGSizeMake(view_.detailScrollView.bounds.size.width * datas.count, view_.detailScrollView.bounds.size.height);
    view_.detailPageControl.numberOfPages = datas.count;
    view_.detailPageControl.currentPage = 0;
    
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
