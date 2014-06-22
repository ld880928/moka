//
//  MOKADetailView.m
//  linker
//
//  Created by 李迪 on 14-6-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MOKADetailView.h"

@interface MOKADetailView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@end

@implementation MOKADetailView

+ (instancetype)MOKADetailViewWithData:(id)data_
{
    MOKADetailView *view = [[[NSBundle mainBundle] loadNibNamed:@"MOKADetailView" owner:self options:nil] lastObject];
    
    view.backgroundImageView.image = [UIImage imageNamed:data_];
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:view
                                                                                   action:@selector(back:)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionDown;
    [view addGestureRecognizer:swipeGes];
    
    return view;
}

- (IBAction)gotoDetail:(id)sender
{
    if (self.gotoDetailBlock) {
        self.gotoDetailBlock();
    }
}

- (void)back:(UISwipeGestureRecognizer *)ges
{
    if (self.backBlock) {
        self.backBlock();
    }
}

@end
