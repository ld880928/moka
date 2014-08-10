//
//  MOKADetailViewController.m
//  linker
//
//  Created by colin on 14-7-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MOKADetailViewController.h"
#import "MOKADetailView.h"

@interface MOKADetailViewController ()

@end

@implementation MOKADetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    MOKADetailView *detailView = [MOKADetailView MOKADetailViewWithData:self.data];
    
    if (self.isMime) {
        detailView.buttonRefuseProcess.hidden = NO;
    }
    
    if (self.status) {
        detailView.imageViewStatus.hidden = NO;
        detailView.imageViewStatus.image = [UIImage imageNamed:self.status];
    }
    
    [detailView setBackBlock:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [detailView setGotoDetailBlock:^{
        [self performSegueWithIdentifier:@"MOKADetailMessageViewControllerSegue" sender:nil];
    }];
    
    detailView.frame = self.view.frame;
    self.view = detailView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
