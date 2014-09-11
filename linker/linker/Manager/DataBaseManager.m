//
//  DataBaseManager.m
//  ganqishi
//
//  Created by jijeMac2 on 14-5-9.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDB.h"

#import "Models.h"

@interface DataBaseManager()
@end

@implementation DataBaseManager

+ (DataBaseManager *)sharedManager
{
    static DataBaseManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        sharedAccountManagerInstance.dataBasePath = PATH_DOCUMENTS;
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedAccountManagerInstance.dataBasePath stringByAppendingPathComponent:DB_NAME]];
        if ([db open]) {
            [db beginTransaction];
            
            [db executeUpdate:TABLE_CREATE_SQL_CITY];
            [db executeUpdate:TABLE_CREATE_SQL_CATEGORY];
            
            [db commit];
            [db close];
        }
        
    });
    return sharedAccountManagerInstance;
}

- (id)getAllCity
{
    NSMutableArray *citys = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self.dataBasePath stringByAppendingPathComponent:DB_NAME]];
    if ([db open]) {
        [db beginTransaction];
        
        NSString *sql = @"SELECT * FROM t_city";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            MCity *city = [[MCity alloc] initWithFMResultSet:rs];
            [citys addObject:city];
        }
        
        [db commit];
        [db close];
    }
    
    return citys;
}

- (void)insertCitys:(id)citys_
{
    NSArray *citys = citys_;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self.dataBasePath stringByAppendingPathComponent:DB_NAME]];
    if ([db open]) {
        [db beginTransaction];
        
        NSString *sql = @"DELETE FROM t_city";
        [db executeUpdate:sql];

        for (MCity * mCity in citys) {
            NSString *sql = @"INSERT INTO t_city(f_city_id,f_city_name) VALUES (?,?)";
            [db executeUpdate:sql,mCity.f_city_id,mCity.f_city_name];
        }
        
        [db commit];
        [db close];
    }
}

- (id)getCategorysByCity:(id)city_
{
    
    MCity *mCity = city_;
    
    NSMutableArray *categorys = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self.dataBasePath stringByAppendingPathComponent:DB_NAME]];
    if ([db open]) {
        [db beginTransaction];
        
        NSString *sql = @"SELECT * FROM t_category WHERE f_city_id=?";
        FMResultSet *rs = [db executeQuery:sql,mCity.f_city_id];
        while ([rs next]) {
            MCategory *category = [[MCategory alloc] initWithFMResultSet:rs];
            [categorys addObject:category];
        }
        
        [db commit];
        [db close];
    }
    
    return categorys;
}

- (void)insertCategorys:(id)categorys_ city:(id)city_
{
    NSArray *categorys = categorys_;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self.dataBasePath stringByAppendingPathComponent:DB_NAME]];
    if ([db open]) {
        [db beginTransaction];
        
        NSString *sql = @"DELETE FROM t_category WHERE f_city_id=?";
        [db executeUpdate:sql,[city_ f_city_id]];
        
        for (MCategory * mCategory in categorys) {
            NSString *sql = @"INSERT INTO t_category(id, f_category_id,f_category_icon,f_category_name,f_city_id) VALUES (?,?,?,?,?)";
            [db executeUpdate:sql,mCategory.ID,mCategory.f_category_id,mCategory.f_category_icon,mCategory.f_category_name,[city_ f_city_id]];
        }
        
        [db commit];
        [db close];
    }
}
/*
- (void)updateUserInfo:(id)userInfo_
{
    FMDatabase *db = [FMDatabase databaseWithPath:[PATH_DOCUMENTS stringByAppendingPathComponent:DB_NAME_USER]];
    if ([db open]) {
        [db beginTransaction];
        
        NSString *sql = @"SELECT count(*) FROM t_user WHERE f_store_id=? AND f_user_name=?";
        NSUInteger count = [db intForQuery:sql,[userInfo_ objectForKey:@"f_store_id"],[userInfo_ objectForKey:@"f_user_name"]];
        //存在就更新
        if (count) {
            sql = @"UPDATE t_user SET f_user_password=? ,f_login_current=? WHERE f_store_id=? AND f_user_name=?";
            [db executeUpdate:sql,
             [userInfo_ objectForKey:@"f_user_password"],
             [userInfo_ objectForKey:@"f_login_current"],
             [userInfo_ objectForKey:@"f_store_id"],
             [userInfo_ objectForKey:@"f_user_name"]];
        }
        else
        {
            //不存在就插入
            sql = @"INSERT INTO t_user (f_store_id,f_user_name,f_user_password,f_login_current,f_huomian_step, f_debug_on) VALUES (?,?,?,?,?,?)";
            [db executeUpdate:sql,
             [userInfo_ objectForKey:@"f_store_id"],
             [userInfo_ objectForKey:@"f_user_name"],
             [userInfo_ objectForKey:@"f_user_password"],
             [userInfo_ objectForKey:@"f_login_current"],
             [userInfo_ objectForKey:@"f_huomian_step"],
             [userInfo_ objectForKey:@"f_debug_on"]];
        }
        
        [db commit];
        [db close];
    }

}
*/
@end
