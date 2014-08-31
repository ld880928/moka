//
//  MMerchantDetail.m
//  linker
//
//  Created by colin on 14-8-27.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MMerchantDetail.h"

@implementation MMerchantDetail

- (instancetype)initWithFMResultSet:(FMResultSet *)rs_
{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic_
{
    if (self=[super init]) {
        self.f_merchant_detail_name = [dic_ objectForKey:@"title"];
        self.f_merchant_detail_description = [dic_ objectForKey:@"merchant_detail"];
        self.f_merchant_detail_image = [dic_ objectForKey:@"imageurl"];
    }
    
    return self;
}

@end
