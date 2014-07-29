//
//  ZCategory.m
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "ZCategory.h"
#import "MCategory.h"

@implementation ZCategory

- (instancetype)initWithDictionary:(NSDictionary *)dic_ city:(ZCity *)city_
{
    if (self=[super init]) {
        self.categoryID = [dic_ objectForKey:@"id"];
        self.categoryName = [dic_ objectForKey:@"name"];
        self.categoryIcon = [dic_ objectForKey:@"icon"];
        self.cityID = city_.cityID;
    }
    
    return self;
}

- (instancetype)initWithCoreDataObject:(id)object
{
    MCategory *mCategory = object;
    
    if (self=[super init]) {
        self.categoryID = mCategory.categoryID;
        self.categoryName = mCategory.categoryName;
        self.categoryIcon = mCategory.categoryIcon;
        self.cityID = mCategory.cityID;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.categoryID forKey:@"categoryID"];
    [encoder encodeObject:self.categoryName forKey:@"categoryName"];
    [encoder encodeObject:self.categoryIcon forKey:@"categoryIcon"];
    [encoder encodeObject:self.cityID forKey:@"cityID"];

}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.categoryID = [decoder decodeObjectForKey:@"categoryID"];
        self.categoryName = [decoder decodeObjectForKey:@"categoryName"];
        self.categoryIcon = [decoder decodeObjectForKey:@"categoryIcon"];
        self.cityID = [decoder decodeObjectForKey:@"cityID"];
    }
    
    return  self;
}
@end
