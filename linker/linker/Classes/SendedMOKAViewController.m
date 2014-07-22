//
//  SendedMOKAViewController.m
//  linker
//
//  Created by 李迪 on 14-6-21.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "SendedMOKAViewController.h"
#import "MOKADetailView.h"
#import "POP/POP.h"
#import "RecivedMOKACell.h"
#import "CustomLayout.h"
#import "MOKADetailView.h"
#import "MOKADetailViewController.h"

@interface SendedMOKAViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *recivedMOKACollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *iconsScrollView;

@property (strong,nonatomic)NSMutableArray *mokaDatasArray;
@end

@implementation SendedMOKAViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15.0f, 15.0f, 23.0f, 40.0f);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (self.callWindowBackBlock) {
            self.callWindowBackBlock();
        }
    }];
    
    [self.view addSubview:backBtn];
    
    // Do any additional setup after loading the view.
    self.mokaDatasArray = [NSMutableArray arrayWithArray:@[@"Image_1",@"Image_2",@"Image_3",@"Image_4"]];
    
    [self.recivedMOKACollectionView registerNib:[UINib nibWithNibName:@"RecivedMOKACell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"RecivedMOKACell"];
    CustomLayout *customLayout = [[CustomLayout alloc] init];
    customLayout.mokaDatasArray = self.mokaDatasArray;
    self.recivedMOKACollectionView.collectionViewLayout = customLayout;
    
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
        
        [self.iconsScrollView addSubview:imageView];
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
    detailView.transform = CGAffineTransformMakeScale(190.0f / 320.0f, 340.0f / 568.0f);
    detailView.center = CGPointMake(cell.contentView.bounds.size.width / 2, cell.contentView.bounds.size.height / 2);
    cell.viewContent = detailView;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"MOKADetailViewControllerSegue" sender:[self.mokaDatasArray objectAtIndex:indexPath.item]];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MOKADetailViewControllerSegue"]) {
        MOKADetailViewController *controller = segue.destinationViewController;
        controller.data = sender;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
