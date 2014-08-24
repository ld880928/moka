//
//  MCategory.m
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MCategory.h"
#import "FMResultSet.h"

@implementation MCategory

- (instancetype)initWithFMResultSet:(FMResultSet *)rs_
{
    if (self = [super init]) {
        self.f_category_id        = [rs_ objectForColumnName:@"f_category_id"];
        self.f_category_icon      = [rs_ objectForColumnName:@"f_category_icon"];
        self.f_category_name      = [rs_ objectForColumnName:@"f_category_name"];
        self.f_city_id            = [rs_ objectForColumnName:@"f_city_id"];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic_
{
    if (self=[super init]) {
        self.f_category_id   = [dic_ objectForKey:@"id"];
        self.f_category_icon = [dic_ objectForKey:@"icon"];
        self.f_category_name = [dic_ objectForKey:@"name"];
        self.f_city_id       = @"";
    }
    
    return self;
}
@end
