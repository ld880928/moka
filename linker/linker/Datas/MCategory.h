//
//  MCategory.h
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMResultSet;

@interface MCategory : NSObject

@property (nonatomic, strong) NSNumber * ID;

@property (nonatomic, strong) NSString * f_category_id;
@property (nonatomic, strong) NSString * f_category_icon;
@property (nonatomic, strong) NSString * f_category_name;
@property (nonatomic, strong) NSString * f_city_id;

- (instancetype)initWithFMResultSet:(FMResultSet *)rs_;
- (instancetype)initWithDictionary:(NSDictionary *)dic_;

@end
