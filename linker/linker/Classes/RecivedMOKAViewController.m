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

@interface RecivedMOKAViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *recivedMOKATableView;
@property (strong,nonatomic)NSMutableArray *mokaDatasArray;

@property(strong,nonatomic)NSMutableArray *tempArray;
@end

@implementation RecivedMOKAViewController

- (IBAction)backToMyCenter:(id)sender
{
    if (self.callWindowBackBlock) {
        self.callWindowBackBlock();
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.tempArray = [NSMutableArray array];
    
    self.mokaDatasArray = [NSMutableArray arrayWithArray:@[@"Image_1",@"Image_2",@"Image_3",@"Image_4"]];
    [self.recivedMOKATableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mokaDatasArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.mokaDatasArray.count - 1) {
        return self.view.bounds.size.height - 73.0f;
    }
    else return 73.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"RecivedMOKACell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *v in [cell.contentView subviews]) {
        [v removeFromSuperview];
    }
    
    
    MOKADetailView *mokaDetailView = [MOKADetailView MOKADetailViewWithData:[self.mokaDatasArray objectAtIndex:indexPath.row]];
    mokaDetailView.frame = CGRectMake(0, 0, mokaDetailView.bounds.size.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    
    UIGraphicsBeginImageContext(mokaDetailView.frame.size);
    [mokaDetailView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:viewSnapShot];
    imageView.frame = mokaDetailView.frame;
    
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSArray *visibleCells = [tableView visibleCells];
    for (int i=0; i<[visibleCells count]; i++) {
        UITableViewCell *cell = [visibleCells objectAtIndex:i];
        CGRect frame = [tableView convertRect:cell.frame toView:self.view];
        
        int row = [[tableView indexPathForCell:cell] row];
        
        if (row < indexPath.row) {
            UIView *v = [[UIView alloc] initWithFrame:frame];
            
            UIGraphicsBeginImageContext(cell.frame.size);
            [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            v.layer.contents = (__bridge id)viewSnapShot.CGImage;
            
            [self.view addSubview:v];
            [self.tempArray addObject:@{@"view": v,@"frame":[NSValue valueWithCGRect:frame]}];
            
            POPBasicAnimation *animationToBottom = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animationToBottom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animationToBottom.duration = .5f;
            
            animationToBottom.toValue = [NSValue valueWithCGRect:CGRectMake(0,
                                                                            -frame.size.height,
                                                                            frame.size.width,
                                                                            frame.size.height)];
            
            [animationToBottom setCompletionBlock:^(POPAnimation *popAnimation, BOOL finished) {
                
            }];
            
            [v pop_addAnimation:animationToBottom forKey:@"animation_zoom_cell"];
        }
        else if(row == indexPath.row)
        {
            MOKADetailView *mokaDetailView = [MOKADetailView MOKADetailViewWithData:[self.mokaDatasArray objectAtIndex:indexPath.row]];
            mokaDetailView.frame = frame;
            
            __unsafe_unretained RecivedMOKAViewController *safe_self = self;
            
            [mokaDetailView setGotoDetailBlock:^{
                [safe_self performSegueWithIdentifier:@"MOKADetailMessageViewController" sender:self];
            }];
            
            [mokaDetailView setBackBlock:^{
                
                for (NSDictionary *dic in self.tempArray) {
                    UIView *v = [dic objectForKey:@"view"];
                    
                    POPBasicAnimation *animationToBottom = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
                    animationToBottom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                    animationToBottom.duration = .5f;
                    
                    animationToBottom.toValue = [dic objectForKey:@"frame"];
                    
                    [animationToBottom setCompletionBlock:^(POPAnimation *popAnimation, BOOL finished) {
                        [v removeFromSuperview];
                        [self.tempArray removeObject:dic];
                    }];
                    
                    [v pop_addAnimation:animationToBottom forKey:@"animation_back_cell"];
                }
                
            }];
            [self.view addSubview:mokaDetailView];
            [self.tempArray addObject:@{@"view": mokaDetailView,@"frame":[NSValue valueWithCGRect:frame]}];

            
            POPBasicAnimation *animationToBottom = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animationToBottom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animationToBottom.duration = .5f;
            
            animationToBottom.toValue = [NSValue valueWithCGRect:CGRectMake(0,
                                                                            0,
                                                                            self.view.bounds.size.width,
                                                                            self.view.bounds.size.height)];
            
            [animationToBottom setCompletionBlock:^(POPAnimation *popAnimation, BOOL finished) {
                
            }];
            
            [mokaDetailView pop_addAnimation:animationToBottom forKey:@"animation_zoom_cell"];
        }
        else
        {
            UIView *v = [[UIView alloc] initWithFrame:frame];
            
            UIGraphicsBeginImageContext(cell.frame.size);
            [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            v.layer.contents = (__bridge id)viewSnapShot.CGImage;
            
            [self.view addSubview:v];
            [self.tempArray addObject:@{@"view": v,@"frame":[NSValue valueWithCGRect:frame]}];
            
            POPBasicAnimation *animationToBottom = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animationToBottom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animationToBottom.duration = .5f;
            
            animationToBottom.toValue = [NSValue valueWithCGRect:CGRectMake(0,
                                                                            self.view.bounds.size.height,
                                                                            frame.size.width,
                                                                            frame.size.height)];
            
            [animationToBottom setCompletionBlock:^(POPAnimation *popAnimation, BOOL finished) {
                
            }];
            
            [v pop_addAnimation:animationToBottom forKey:@"animation_zoom_cell"];
        }
        
    }

    
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
