//
//  MOKADetailViewController.m
//  linker
//
//  Created by colin on 14-7-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MOKADetailViewController.h"
#import "MOKADetailView.h"
#import "MOKADetailMessageViewController.h"

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
    
    
    [detailView setBackBlock:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [detailView setGotoDetailBlock:^(MMoka *moka){
        [self performSegueWithIdentifier:@"MOKADetailMessageViewControllerSegue" sender:moka];
    }];
    
    detailView.frame = self.view.frame;
    self.view = detailView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MOKADetailMessageViewController *controller = segue.destinationViewController;
    controller.moka = sender;
}

@end
