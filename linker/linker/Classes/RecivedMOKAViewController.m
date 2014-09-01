//
//  RecivedMOKAViewController.m
//  linker
//
//  Created by 李迪 on 14-6-21.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "RecivedMOKAViewController.h"
#import "MOKADetailView.h"
#import "POP/POP.h"
#import "RecivedMOKACell.h"
#import "CustomLayout.h"
#import "MOKADetailView.h"
#import "MOKADetailViewController.h"
#import "BusinessWindow.h"

@interface RecivedMOKAViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *recivedMOKACollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *iconsScrollView;

@property (strong,nonatomic)NSMutableArray *mokaDatasArray;
@end

@implementation RecivedMOKAViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home"]];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20.0f, 50.0f, 44.0f);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        self.recivedMOKACollectionView.layer.masksToBounds = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
        [[BusinessWindow sharedBusinessWindow] hideToShow];

    }];

    [self.view addSubview:backBtn];
    
    // Do any additional setup after loading the view.
    self.mokaDatasArray = [NSMutableArray arrayWithArray:@[@"Image_1",@"Image_2",@"Image_3",@"Image_4"]];

    [self.recivedMOKACollectionView registerNib:[UINib nibWithNibName:@"RecivedMOKACell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"RecivedMOKACell"];
    CustomLayout *customLayout = [[CustomLayout alloc] init];
    customLayout.cellCount = self.mokaDatasArray.count;
    self.recivedMOKACollectionView.collectionViewLayout = customLayout;
    self.recivedMOKACollectionView.layer.masksToBounds = NO;
    
    [self.recivedMOKACollectionView reloadData];

    [self.recivedMOKACollectionView performBatchUpdates:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
    self.iconsScrollView.delegate = self;
    for (int i=0; i < self.mokaDatasArray.count; i++) {
        
        UIImage *image = [UIImage imageNamed:@"shop_icon_1"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        imageView.image = image;
        imageView.center = CGPointMake(320.0f * i + 320.0f / 2, 45.0f / 2 + 20);
        
        imageView.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        imageView.layer.shadowRadius = 5.0;
        imageView.layer.shadowOpacity = 1.0f;
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        [self.iconsScrollView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 21.0f)];
        label.text = @"仟吉西饼";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.center = CGPointMake(320.0f * i + 320.0f / 2, (45.0f + 30.0f) + 21.0f / 2);
        
        label.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        label.layer.shadowRadius = 5.0;
        label.layer.shadowOpacity = 1.0f;
        label.layer.shadowColor = [UIColor blackColor].CGColor;
        
        [self.iconsScrollView addSubview:label];
    }
    
    self.iconsScrollView.contentSize = CGSizeMake(320.0f * self.mokaDatasArray.count, 128.0f);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat a = (190.0f + 10.0f) / 320.0f;
    if (scrollView == self.iconsScrollView) {
        self.recivedMOKACollectionView.contentOffset = CGPointMake(scrollView.contentOffset.x * a, self.recivedMOKACollectionView.contentOffset.y);
    }
    else
    {
        self.iconsScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x / a, self.iconsScrollView.contentOffset.y);
        
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mokaDatasArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"RecivedMOKACell";
    
    RecivedMOKACell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    
    MOKADetailView *detailView = [MOKADetailView MOKADetailViewWithData:[self.mokaDatasArray objectAtIndex:indexPath.item]];
    
    if (indexPath.item == 1) {
        detailView.imageViewStatus.hidden = NO;
        detailView.imageViewStatus.image = [UIImage imageNamed:@"mokastatus_3"];
    }
    
    detailView.transform = CGAffineTransformMakeScale(190.0f / 320.0f, 340.0f / 568.0f);
    detailView.center = CGPointMake(cell.contentView.bounds.size.width / 2, cell.contentView.bounds.size.height / 2);
    cell.viewContent = detailView;
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    cell.layer.shadowRadius = 5.0;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    [self performSegueWithIdentifier:@"MOKADetailViewControllerSegue" sender:indexPath];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MOKADetailViewControllerSegue"]) {
        MOKADetailViewController *controller = segue.destinationViewController;
        
        NSIndexPath *indexPath = sender;
        if (indexPath.item == 1) {
            controller.status = @"mokastatus_3";
        }
        controller.data = [self.mokaDatasArray objectAtIndex:indexPath.item];
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
