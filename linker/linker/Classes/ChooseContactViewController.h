//
//  ChooseContactViewController.h
//  linker
//
//  Created by colin on 14-9-1.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseContactViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray *contacts;

@property(nonatomic,copy)void(^chooseSuccessBlock)(NSDictionary *contact);

@end
