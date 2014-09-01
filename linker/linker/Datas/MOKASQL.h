//
//  MOKASQL.h
//  linker
//
//  Created by 李迪 on 14-8-16.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#ifndef linker_MOKASQL_h
#define linker_MOKASQL_h

#define PATH_DOCUMENTS NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define PATH_LIBRARY NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]
#define PATH_CACHE NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

//数据库名
#define DB_NAME @"moka.sqlite"

#define TABLE_CREATE_SQL_CITY @"CREATE TABLE IF NOT EXISTS t_city (f_city_id TEXT PRIMARY KEY, f_city_name TEXT)"
#define TABLE_CREATE_SQL_CATEGORY @"CREATE TABLE IF NOT EXISTS t_category (id INTEGER PRIMARY KEY AUTOINCREMENT ,f_category_id TEXT , f_category_icon TEXT, f_category_name TEXT, f_city_id TEXT)"

#endif
