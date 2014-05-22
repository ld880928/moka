//
//  BusinessDetailViewController.m
//  linker
//
//  Created by 李迪 on 14-5-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "BusinessDetailViewController.h"

@interface BusinessDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmPayment;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;

@end

@implementation BusinessDetailViewController

- (IBAction)cancle:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)confirmPayment:(id)sender {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.btnCancle.layer.borderWidth = 1.0f;
    self.btnCancle.layer.borderColor = [UIColor blueColor].CGColor;
    self.btnCancle.layer.cornerRadius = 5.0f;
    [self.btnCancle setBackgroundImage:[self createImageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
    self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    
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
@end
