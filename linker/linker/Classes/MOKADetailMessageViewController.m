//
//  MOKADetailMessageViewController.m
//  linker
//
//  Created by 李迪 on 14-6-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MOKADetailMessageViewController.h"
#import "UIView+TopRadius.h"

@interface MOKADetailMessageViewController ()
@property (weak, nonatomic) IBOutlet UIView *detailMessageView;

@end

@implementation MOKADetailMessageViewController

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.detailMessageView dwMakeTopRoundCornerWithRadius:10.0f];
}



@end
