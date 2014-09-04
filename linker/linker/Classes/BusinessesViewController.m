//
//  BusinessesViewController.m
//  linker
//
//  Created by 李迪 on 14-5-17.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessesViewController.h"
#import "BusinessWindow.h"
#import "BusinessView.h"
#import "BusinessDetailViewController.h"
#import "Models.h"

@interface BusinessesViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *businessesScrollView;
@property (nonatomic,strong)NSMutableArray *businessArray;
@property (strong, nonatomic)UILabel *navigationLabel;
@property (strong,nonatomic)MCity *currentCity;
@end

@implementation BusinessesViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)refreshDataWithCityID:(MCity *)city category:(MCategory *)category_
{
    self.currentCity = city;
    
    self.navigationLabel.text = category_.f_category_name;
    
    [SVProgressHUD showWithStatus:@"正在加载商家信息..." maskType:SVProgressHUDMaskTypeGradient];
    
    //请求商家
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    [manager POST:URL_SUB_GETMERCHANT parameters:@{@"city_id": city.f_city_id,@"category_id":@"8"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
        for (UIView *v in [self.businessesScrollView subviews]) {
            [v removeFromSuperview];
        }
        
        self.businessArray = [NSMutableArray array];
        
        for (int i=0; i<[responseObject count]; i++) {
            
            NSDictionary *data = [responseObject objectAtIndex:i];
            
            MMerchant *mMerchant = [[MMerchant alloc] initWithDictionary:data];
            
            NSArray *detailDatas = [data objectForKey:@"merchantdetail"];
            
            if ([detailDatas isEqual:[NSNull null]]) {
                detailDatas = nil;
            }
            
            NSMutableArray *details = [NSMutableArray array];
            for (int j=0; j<detailDatas.count; j++) {
                
                NSDictionary *dataDtail = [detailDatas objectAtIndex:j];
                
                MMerchantDetail *mMerchantDetail = [[MMerchantDetail alloc] initWithDictionary:dataDtail];
                [details addObject:mMerchantDetail];
            }
            
            mMerchant.details = details;
            
            [self.businessArray addObject:mMerchant];
        }
        
        for (int i=0; i<self.businessArray.count; i++) {
            
            MMerchant *mMerchant = [self.businessArray objectAtIndex:i];
            
            BusinessView *view_ = [BusinessView businessViewWithDatas:mMerchant];
            
            view_.frame = CGRectMake(self.view.bounds.size.width * i, 0, self.businessesScrollView.bounds.size.width, self.businessesScrollView.bounds.size.height);
            view_.userInteractionEnabled = YES;
            
            [self.businessesScrollView addSubview:view_];
            
            UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            panGes.delegate = self;
            [view_ addGestureRecognizer:panGes];
            
            [view_ setGotoDetailBlock:^{
                [self performSegueWithIdentifier:@"BusinessDetail" sender:mMerchant];
            }];
            
            __unsafe_unretained BusinessView *safeView_ = view_;
            
            [view_ setGotoTopFinishedCallBackBlock:^(BOOL finished) {
                self.businessesScrollView.scrollEnabled = NO;
                safeView_.detailView.detailScrollView.scrollEnabled = YES;
                
            }];
            
            [view_ setGotoBottomFinishedCallBackBlock:^(BOOL finished) {
                self.businessesScrollView.scrollEnabled = YES;
                safeView_.detailView.detailScrollView.scrollEnabled = YES;
            }];
            
            [view_ setPositionYChangedCallBackBlock:^(CGFloat percent) {
                CGFloat distance = 55.0f;
                CGFloat navigationY = 15.0f - (1.0f - percent) * distance;
                CGRect frame = self.navigationLabel.frame;
                frame.origin.y = navigationY;
                self.navigationLabel.frame = frame;
            }];
        }
        
        self.businessesScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * self.businessArray.count, self.businessesScrollView.bounds.size.height);
        
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
        id a = responseObject;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];

        NSLog(@"%@",error);
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.businessesScrollView setCanCancelContentTouches:YES];
    
    BusinessWindow *businessWindow = [BusinessWindow sharedBusinessWindow];
    businessWindow.gotoTopFinishedCallBackBlock = ^(BOOL finished){
        self.businessesScrollView.scrollEnabled = YES;
    };
    businessWindow.gotoBottomFinishedCallBackBlock = ^(BOOL finished){
        self.businessesScrollView.scrollEnabled = NO;
    };
    
    self.navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 200.0f, 40.0f)];
    self.navigationLabel.font = [UIFont systemFontOfSize:32.0f];
    self.navigationLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationLabel];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)ges_
{
    if ([ges_.view isKindOfClass:[BusinessView class]]) {
        
        BusinessView *businessView = (BusinessView *)ges_.view;
        BusinessWindow *businessWindow = [BusinessWindow sharedBusinessWindow];
        
        int page = self.businessesScrollView.contentOffset.x / self.businessesScrollView.bounds.size.width;
        CGFloat distance = self.businessesScrollView.contentOffset.x -  self.businessesScrollView.bounds.size.width * page;
        
        int page_detailViewContainerScrollView = businessView.detailView.detailScrollView.contentOffset.x / businessView.detailView.detailScrollView.bounds.size.width;
        CGFloat  distance_detailViewContainerScrollView = businessView.detailView.detailScrollView.contentOffset.x - businessView.detailView.detailScrollView.bounds.size.width *page_detailViewContainerScrollView;
        
        CGFloat distance_y = [ges_ translationInView:self.view].y;
        
        CGFloat businessWindow_y = businessWindow.frame.origin.y;
        CGFloat businessView_y = businessView.bottomContainerView.frame.origin.y;
        
        switch (ges_.state) {
            case UIGestureRecognizerStateBegan:
            {
                break;
            }
            case UIGestureRecognizerStateChanged:
            {
                if (self.businessesScrollView.isDragging || distance != 0 || distance_detailViewContainerScrollView != 0) {
                    return;
                }
                
                if (businessWindow.businessWindowState == BusinessWindowState_Moving || businessView.businessViewState == BusinessViewState_DetailMoving) {
                    businessView.detailView.detailScrollView.scrollEnabled = NO;
                    self.businessesScrollView.scrollEnabled = NO;
                }
                
                if (distance_y > 0) {
                    //向下拖动
                    if (businessView.businessViewState == BusinessViewState_DetailHide) {
                        //直接向下拖动window
                        businessWindow_y = businessWindow_y + distance_y;
                        businessWindow_y = businessWindow_y < 0 ? 0 : businessWindow_y;
                        businessWindow_y = businessWindow_y > businessWindow.bounds.size.height ? businessWindow.bounds.size.height : businessWindow_y;
                        [businessWindow resetPositionY:businessWindow_y];
                        businessWindow.businessWindowState = BusinessWindowState_Moving;
                    }
                    else
                    {
                       //向下拖动详细view
                        businessView_y = businessView_y + distance_y;
                        businessView_y = businessView_y < 0 ? 0 : businessView_y;
                        businessView_y = businessWindow_y > [businessView getBottom_y] ? [businessView getBottom_y] : businessView_y;
                        [businessView resetPositionY:businessView_y];
                        businessView.businessViewState = BusinessViewState_DetailMoving;
                        
                    }
                }
                else
                {
                    //向上拖动
                    if (businessWindow.businessWindowState == BusinessWindowState_Moving || businessWindow.businessWindowState == BusinessWindowState_Hide) {
                        //向上拖动window
                        businessWindow_y = businessWindow_y + distance_y;
                        businessWindow_y = businessWindow_y < 0 ? 0 : businessWindow_y;
                        businessWindow_y = businessWindow_y > businessWindow.bounds.size.height ? businessWindow.bounds.size.height : businessWindow_y;
                        [businessWindow resetPositionY:businessWindow_y];
                        businessWindow.businessWindowState = BusinessWindowState_Moving;
                        
                    }
                    else
                    {
                        //向上拖动详细view
                        businessView_y = businessView_y + distance_y;
                        businessView_y = businessView_y < 0 ? 0 : businessView_y;
                        businessView_y = businessWindow_y > [businessView getBottom_y] ? [businessView getBottom_y] : businessView_y;
                        [businessView resetPositionY:businessView_y];
                        businessView.businessViewState = BusinessViewState_DetailMoving;
                        
                    }
                    
                }
                
                break;
            }
            case UIGestureRecognizerStateEnded:
            {
                
                if (distance != 0 || distance_detailViewContainerScrollView != 0) {
                    return;
                }
                
                CGFloat speed_y = [ges_ velocityInView:self.view].y;
                
                if (speed_y > SPEED) {
                    if (businessWindow.businessWindowState == BusinessWindowState_Moving) {
                        [businessWindow moveToBottom];
                    }
                    else
                    {
                        //详细信息拖动到最下面去
                        [businessView moveToBottom];
                    }
                }
                else if(speed_y < -1 * SPEED)
                {
                    if (businessWindow.businessWindowState == BusinessWindowState_Moving) {
                        [businessWindow moveToTop];
                    }
                    else
                    {
                        //详细信息显示到上面
                        [businessView moveToTop];
                    }

                }
                else
                {
                    businessWindow_y = businessWindow_y + distance_y;
                    businessWindow_y = businessWindow_y < 0 ? 0 : businessWindow_y;
                    businessWindow_y = businessWindow_y > businessWindow.bounds.size.height ? businessWindow.bounds.size.height : businessWindow_y;
                    if (businessWindow_y < self.view.frame.size.height / 2) {
                        if (businessWindow.businessWindowState == BusinessWindowState_Moving) {
                            [businessWindow moveToTop];
                        }
                    }
                    else
                    {
                        if (businessWindow.businessWindowState == BusinessWindowState_Moving) {
                            [businessWindow moveToBottom];
                        }
                    }
                    
                    businessView_y = businessView_y + distance_y;
                    businessView_y = businessView_y < 0 ? 0 : businessView_y;
                    businessView_y = businessView_y > [businessView getBottom_y]? [businessView getBottom_y] : businessView_y;
                    if (businessView_y < self.view.frame.size.height / 2) {
                        if (businessView.businessViewState == BusinessViewState_DetailMoving) {
                            [businessView moveToTop];
                        }
                    }
                    else
                    {
                        if (businessView.businessViewState == BusinessViewState_DetailMoving) {
                            [businessView moveToBottom];
                        }
                    }
                    
                }
                break;
            }
            default:
                break;
        }
        
        [ges_ setTranslation:CGPointZero inView:self.view];
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BusinessDetailViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.mMerchant = sender;
    destinationViewController.currentCity = self.currentCity;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.businessesScrollView) {
        //解决一个拖动的冲突
        BusinessWindow *businessWindow = [BusinessWindow sharedBusinessWindow];
        if (businessWindow.frame.origin.y > 0) {
            [businessWindow resetPositionY:0];
        }
    }
}

@end
