//
//  MMerchant.h
//  linker
//
//  Created by colin on 14-8-27.
//  Copyright (c) 2014年 colin. All rights reserved.
//
/*!
 *  商家
 */
#import <Foundation/Foundation.h>
@class FMResultSet;

@interface MMerchant : NSObject
@property (nonatomic, strong) NSNumber * ID;
@property (nonatomic, strong) NSNumber * f_merchant_index;
@property (nonatomic, strong) NSNumber * f_merchant_consume_num;       //consume_num

@property (nonatomic, strong) NSString * f_merchant_id;                //merchant_id
@property (nonatomic, strong) NSString * f_category_id;
@property (nonatomic, strong) NSString * f_merchant_name;              //merchant_name
@property (nonatomic, strong) NSString * f_merchant_description;       //merchant_intro
@property (nonatomic, strong) NSString * f_merchant_background_image;  //merchant_backgroundimage
@property (nonatomic, strong) NSString * f_merchant_logo_image;        //brand_log
@property (nonatomic, strong) NSString * f_merchant_logo_name;         //brand_name

@property (nonatomic, strong) NSMutableArray *details;

- (instancetype)initWithFMResultSet:(FMResultSet *)rs_;
- (instancetype)initWithDictionary:(NSDictionary *)dic_;

@end
