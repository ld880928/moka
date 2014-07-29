//
//  ZCity.m
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "ZCity.h"
#import "MCity.h"

@implementation ZCity

- (instancetype)initWithDictionary:(NSDictionary *)dic_
{
    if (self=[super init]) {
        self.cityID = [dic_ objectForKey:@"entity_id"];
        self.cityName = [dic_ objectForKey:@"name"];
    }
    
    return self;
}

- (instancetype)initWithCoreDataObject:(id)object
{
    MCity *mCity = object;
    
    if (self=[super init]) {
        self.cityID = mCity.cityID;
        self.cityName = mCity.cityName;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.cityID forKey:@"cityID"];
    [encoder encodeObject:self.cityName forKey:@"cityName"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.cityID = [decoder decodeObjectForKey:@"cityID"];
        self.cityName = [decoder decodeObjectForKey:@"cityName"];
    }
    
    return  self;
}

@end
