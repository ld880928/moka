//
//  ZCity.h
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCity : NSObject

@property (nonatomic, strong) NSString * cityID;
@property (nonatomic, strong) NSString * cityName;

- (instancetype)initWithDictionary:(NSDictionary *)dic_;

- (instancetype)initWithCoreDataObject:(id)object;

@end
