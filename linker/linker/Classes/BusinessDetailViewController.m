//
//  BusinessDetailViewController.m
//  linker
//
//  Created by 李迪 on 14-5-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "BusinessDetailView.h"

@interface BusinessDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *containerScorllView;
@property(nonatomic,strong)BusinessDetailView *businessDetailView;
@end

@implementation BusinessDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = self.backgroundImage;
    self.businessDetailView = [BusinessDetailView businessDetailViewWithDatas:nil];

    __unsafe_unretained BusinessDetailViewController *safe_self = self;
    
    //取消
    [self.businessDetailView setCancleBlock:^{
        [safe_self dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    
    //确认支付
    [self.businessDetailView setConfirmPaymentBlock:^{
        
    }];
    
    [self.businessDetailView setShowShopTableViewBlock:^{
        
        
        [UIView animateWithDuration:.5f animations:^{
            
            safe_self.businessDetailView.topContainerView.frame = CGRectMake(safe_self.businessDetailView.topContainerView.frame.origin.x,
                                                                             safe_self.businessDetailView.topContainerView.frame.origin.y,
                                                                             safe_self.businessDetailView.topContainerView.frame.size.width,
                                                                             200.0f);
            
            safe_self.businessDetailView.bottomContainerView.frame = CGRectMake(safe_self.businessDetailView.bottomContainerView.frame.origin.x,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.origin.y + 200.0f,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.size.width,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.size.height);
        } completion:^(BOOL finished) {
            safe_self.businessDetailView.frame = CGRectMake(safe_self.businessDetailView.frame.origin.x,
                                                            safe_self.businessDetailView.frame.origin.y,
                                                            safe_self.businessDetailView.frame.size.width,
                                                            safe_self.businessDetailView.frame.size.height + 200.0f);
            
            safe_self.containerScorllView.contentSize = safe_self.businessDetailView.bounds.size;
        }];
        
    }];
    
    [self.businessDetailView setHideShopTableViewBlock:^{
        [UIView animateWithDuration:.5f animations:^{
            
            safe_self.businessDetailView.topContainerView.frame = CGRectMake(safe_self.businessDetailView.topContainerView.frame.origin.x,
                                                                             safe_self.businessDetailView.topContainerView.frame.origin.y,
                                                                             safe_self.businessDetailView.topContainerView.frame.size.width,
                                                                             0.0f);
            
            safe_self.businessDetailView.bottomContainerView.frame = CGRectMake(safe_self.businessDetailView.bottomContainerView.frame.origin.x,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.origin.y - 200.0f,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.size.width,
                                                                                safe_self.businessDetailView.bottomContainerView.frame.size.height);
        } completion:^(BOOL finished) {
            safe_self.businessDetailView.frame = CGRectMake(safe_self.businessDetailView.frame.origin.x,
                                                            safe_self.businessDetailView.frame.origin.y,
                                                            safe_self.businessDetailView.frame.size.width,
                                                            safe_self.businessDetailView.frame.size.height - 200.0f);
            safe_self.containerScorllView.contentSize = safe_self.businessDetailView.bounds.size;
        }];

    }];
    
    [self.businessDetailView setAddContactBlock:^{
        
    }];
    
    [self.containerScorllView addSubview:self.businessDetailView];
    self.containerScorllView.contentSize = self.businessDetailView.bounds.size;
}

- (IBAction)showMapView:(id)sender
{
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    firstView.backgroundColor = [UIColor redColor];
    [self.businessDetailView.topContainerView addSubview:firstView];
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    twoView.backgroundColor = [UIColor greenColor];
    [self.businessDetailView.topContainerView insertSubview:twoView belowSubview:firstView];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.businessDetailView.topContainerView cache:YES];
    
    [self.businessDetailView.topContainerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用某个方法
    //[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    [UIView commitAnimations];
}

@end
