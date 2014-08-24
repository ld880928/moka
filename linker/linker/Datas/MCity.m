//
//  MCity.m
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MCity.h"
#import "FMResultSet.h"

@implementation MCity

- (instancetype)initWithFMResultSet:(FMResultSet *)rs_
{
    if (self = [super init]) {
        self.f_city_id        = [rs_ objectForColumnName:@"f_city_id"];
        self.f_city_name      = [rs_ objectForColumnName:@"f_city_name"];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic_
{
    if (self=[super init]) {
        self.f_city_id = [dic_ objectForKey:@"city_id"];
        self.f_city_name = [dic_ objectForKey:@"name"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.f_city_id forKey:@"f_city_id"];
    [aCoder encodeObject:self.f_city_name forKey:@"f_city_name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.f_city_id        = [aDecoder decodeObjectForKey:@"f_city_id"];
        self.f_city_name      = [aDecoder decodeObjectForKey:@"f_city_name"];
    }
    
    return self;
}

@end
