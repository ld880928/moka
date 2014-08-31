//
//  MMerchant.m
//  linker
//
//  Created by colin on 14-8-27.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MMerchant.h"

@implementation MMerchant

- (instancetype)initWithFMResultSet:(FMResultSet *)rs_
{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic_
{
    if (self=[super init]) {
        self.f_merchant_consume_num = [dic_ objectForKey:@"consume_num"];
        self.f_merchant_id = [dic_ objectForKey:@"merchant_id"];
        self.f_merchant_name = [dic_ objectForKey:@"merchant_name"];
        self.f_merchant_description = [dic_ objectForKey:@"merchant_intro"];
        self.f_merchant_background_image = [dic_ objectForKey:@"merchant_backgroundimage"];
        self.f_merchant_logo_image = [dic_ objectForKey:@"brand_log"];
        self.f_merchant_logo_name = [dic_ objectForKey:@"brand_name"];
    }
    
    return self;
}

@end
