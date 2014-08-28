//
//  MMerchantDetail.h
//  linker
//
//  Created by colin on 14-8-27.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMerchantDetail : NSObject
@property (nonatomic, strong) NSNumber * ID;
@property (nonatomic, strong) NSNumber * f_merchant_detail_index;

@property (nonatomic, strong) NSString * f_merchant_detail_name;         //title
@property (nonatomic, strong) NSString * f_merchant_detail_description;  //merchant_detail
@property (nonatomic, strong) NSString * f_merchant_detail_image;        //imageurl

- (instancetype)initWithFMResultSet:(FMResultSet *)rs_;
- (instancetype)initWithDictionary:(NSDictionary *)dic_;

@end
