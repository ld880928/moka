//
//  HomeViewController.m
//  linker
//
//  Created by 李迪 on 14-5-13.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property(nonatomic,strong)UIWindow *windowB;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define DISTANCE_BOTTOM 64.0f
#define DISTANCE_TOP 0
#define SPEED 200.0f

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [self createImageWithColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
    
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.containerView addGestureRecognizer:ges];
    
    
    self.windowB = [[UIWindow alloc] initWithFrame:CGRectMake(0, 300, 320, 568)];
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.windowB.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"BusinessesViewController"];
    self.windowB.backgroundColor = [UIColor whiteColor];
    self.windowB.hidden = NO;
    [self.windowB makeKeyAndVisible];
    
    self.windowB.windowLevel = UIWindowLevelStatusBar + 1;
    [self.windowB addGestureRecognizer:ges];
}

- (void)handlePan:(UIPanGestureRecognizer *)ges_
{
    CGFloat distance_y = [ges_ translationInView:self.view].y;
    
    distance_y = self.windowB.frame.origin.y + distance_y;
    
    switch (ges_.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            
            distance_y = distance_y < 0 ? 0 : distance_y;
            
            distance_y = distance_y > self.view.frame.size.height ? self.view.frame.size.height : distance_y;
            
            self.windowB.frame = CGRectMake(self.windowB.frame.origin.x, distance_y, self.windowB.bounds.size.width, self.windowB.bounds.size.height);
            
            break;
        }
            case UIGestureRecognizerStateEnded:
        {
            
            
            [UIView animateWithDuration:1.0f animations:^{
                
                CGFloat speed_y = [ges_ velocityInView:self.view].y;
                
                CGFloat distance_y_ = distance_y < self.view.frame.size.height / 2 ? DISTANCE_TOP : self.view.frame.size.height - DISTANCE_BOTTOM;
                
                if (speed_y > SPEED) {
                    //往下
                    distance_y_ = self.view.frame.size.height - DISTANCE_BOTTOM;
                }
                else if(speed_y < -1 * SPEED)
                {
                    //往上
                    distance_y_ = DISTANCE_TOP;
                }
                
                self.windowB.frame = CGRectMake(self.windowB.frame.origin.x, distance_y_, self.windowB.bounds.size.width, self.windowB.bounds.size.height);

            } completion:^(BOOL finished) {
                if (self.windowB.frame.origin.y == 0) {
                    [self.windowB removeGestureRecognizer:ges_];
                }
            }];
            
            break;
        }
        default:
            break;
    }
    
    [ges_ setTranslation:CGPointZero inView:self.view];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationViewController = segue.destinationViewController;
    
    if ([@"businessesSegue" isEqualToString:segue.identifier]) {
        NSLog(@"%@",[[destinationViewController class] description]);
        NSLog(@"%@",self.childViewControllers);
    }
    
}


- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
