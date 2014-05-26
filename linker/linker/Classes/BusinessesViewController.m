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

@interface BusinessesViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *businessesScrollView;
@property (nonatomic,strong)NSArray *businessArray;
@end

@implementation BusinessesViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    
    self.businessArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"business_data" ofType:@"plist"]];
    
    for (int i=0; i<self.businessArray.count; i++) {
        
        NSDictionary *businessItem = [self.businessArray objectAtIndex:i];
        
        BusinessView *view_ = [BusinessView businessViewWithDatas:businessItem];
        
        view_.frame = CGRectMake(self.view.bounds.size.width * i, 0, self.businessesScrollView.bounds.size.width, self.businessesScrollView.bounds.size.height);
        view_.userInteractionEnabled = YES;

        view_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[businessItem objectForKey:@"background"]]];
        
        [self.businessesScrollView addSubview:view_];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGes.delegate = self;
        [view_ addGestureRecognizer:panGes];
        
        UIColor *backgroundColor = view_.backgroundColor;
        [view_ setGotoDetailBlock:^{
            [self performSegueWithIdentifier:@"BusinessDetail" sender:backgroundColor];
        }];
        
    }
    
    self.businessesScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * self.businessArray.count, self.businessesScrollView.bounds.size.height);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)ges_
{
    BusinessWindow *businessWindow = [BusinessWindow sharedBusinessWindow];
    
    CGFloat distance_y = [ges_ translationInView:self.view].y;
    
    distance_y = businessWindow.frame.origin.y + distance_y;
    
    switch (ges_.state) {
        case UIGestureRecognizerStateBegan:
        {
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (self.businessesScrollView.isDragging) {
                return;
            }
            if (businessWindow.frame.origin.y > 0) {
                self.businessesScrollView.scrollEnabled = NO;
            }
            
            distance_y = distance_y < 0 ? 0 : distance_y;
            distance_y = distance_y > self.view.frame.size.height ? self.view.frame.size.height : distance_y;
            [businessWindow resetPositionY:distance_y];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGFloat speed_y = [ges_ velocityInView:self.view].y;

            if (speed_y > SPEED) {
                [businessWindow moveToBottom];
            }
            else if(speed_y < -1 * SPEED)
            {
                [businessWindow moveToTop];
            }
            else
            {
                if (distance_y < self.view.frame.size.height / 2) {
                    [businessWindow moveToTop];
                }
                else
                {
                    [businessWindow moveToBottom];
                }
            }
            break;
        }
        default:
            break;
    }
    
    [ges_ setTranslation:CGPointZero inView:self.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BusinessDetailViewController *destinationViewController = segue.destinationViewController;
    [destinationViewController setBackgroundImage:sender];

}

@end
