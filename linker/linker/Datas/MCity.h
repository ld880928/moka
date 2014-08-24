//
//  MCity.h
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface MCity : NSObject <NSCoding>

@property (nonatomic, strong) NSString * f_city_id;
@property (nonatomic, strong) NSString * f_city_name;

- (instancetype)initWithFMResultSet:(FMResultSet *)rs_;
- (instancetype)initWithDictionary:(NSDictionary *)dic_;

@end
