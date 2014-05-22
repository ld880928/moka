//
//  BusinessesViewController.m
//  linker
//
//  Created by 李迪 on 14-5-17.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessesViewController.h"
#import "BusinessDetailViewController.h"

#define DISTANCE_BOTTOM 64.0f
#define DISTANCE_TOP 0
#define SPEED 200.0f

@interface BusinessesViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *businessesScrollView;

@end

@implementation BusinessesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
    [self.businessesScrollView setCanCancelContentTouches:YES];

	// Do any additional setup after loading the view.
    
    for (int i=0; i<3; i++) {
        UIView *view_ = [[UIView alloc] initWithFrame:self.view.bounds];
        view_.frame = CGRectMake(self.view.bounds.size.width * i, 0, self.businessesScrollView.bounds.size.width, self.businessesScrollView.bounds.size.height);
        view_.userInteractionEnabled = YES;
        switch (i) {
            case 0:
                view_.backgroundColor = [UIColor redColor];
                break;
            case 1:
                view_.backgroundColor = [UIColor blueColor];
                break;
            case 2:
                view_.backgroundColor = [UIColor grayColor];
                break;
            default:
                break;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(100, 100, 50, 50);
        [button setTitle:@"给爷一个惊喜" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(gotoDetail) forControlEvents:UIControlEventTouchUpInside];
        [view_ addSubview:button];
        
        UISwipeGestureRecognizer *ges = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        ges.direction = UISwipeGestureRecognizerDirectionDown;
        [view_ addGestureRecognizer:ges];
        
        UISwipeGestureRecognizer *ges1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        ges1.direction = UISwipeGestureRecognizerDirectionUp;
        [view_ addGestureRecognizer:ges1];
        
        [self.businessesScrollView addSubview:view_];
    }
    
    self.businessesScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, self.businessesScrollView.bounds.size.height);
}

- (void)gotoDetail
{
    [self performSegueWithIdentifier:@"BusinessDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BusinessDetailViewController *destinationViewController = segue.destinationViewController;
    [destinationViewController setBackgroundImage:[UIImage imageNamed:@"background_home"]];

}

- (void)handleSwipe:(UISwipeGestureRecognizer *)ges_
{
    NSLog(@"%@",ges_.view);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
