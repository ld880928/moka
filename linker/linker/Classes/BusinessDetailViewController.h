//
//  BusinessDetailViewController.h
//  linker
//
//  Created by 李迪 on 14-5-22.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMerchant;

@interface BusinessDetailViewController : UIViewController
@property(nonatomic,strong)MMerchant *mMerchant;
@property(nonatomic,strong)MCity *currentCity;
@end
