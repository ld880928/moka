//
//  DataBaseManager.h
//  ganqishi
//
//  Created by jijeMac2 on 14-5-9.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOKASQL.h"

@interface DataBaseManager : NSObject
@property(nonatomic,strong)NSString *dataBasePath;

+ (DataBaseManager *)sharedManager;

/*!
 *  获取本地所有推荐城市
 *
 *  @return 城市列表
 */
- (id)getAllCity;

/*!
 *  写入热门城市缓存
 *
 *  @param citys_ 城市列表
 */
- (void)insertCitys:(id)citys_;

- (id)getCategorysByCity:(id)city_;

- (void)insertCategorys:(id)categorys_ city:(id)city_;
@end
