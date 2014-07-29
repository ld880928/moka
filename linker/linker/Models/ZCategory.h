//
//  ZCategory.h
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZCity;

@interface ZCategory : NSObject

@property (nonatomic, strong) NSString * categoryID;
@property (nonatomic, strong) NSString * categoryIcon;
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * cityID;

- (instancetype)initWithDictionary:(NSDictionary *)dic_ city:(ZCity *)city_;

- (instancetype)initWithCoreDataObject:(id)object;

@end
