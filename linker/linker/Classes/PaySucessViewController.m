//
//  PaySucessViewController.m
//  linker
//
//  Created by colin on 14-9-5.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "PaySucessViewController.h"

@interface PaySucessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *merchantName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@end

@implementation PaySucessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imageViewBackground setImageWithURL:self.mMerchant.f_merchant_background_image];
    [self.iconImageView setImageWithURL:self.mMerchant.f_merchant_logo_image];
    self.merchantName.text = self.mMerchant.f_merchant_name;
    
    if ([self.price isKindOfClass:[NSDictionary class]]) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",[self.price objectForKey:@"price"]];
        
    }
    else
        self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.price];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
