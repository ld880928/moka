//
//  MOKAURLs.h
//  linker
//
//  Created by 李迪 on 14-7-28.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#ifndef linker_MOKAURLs_h
#define linker_MOKAURLs_h

#define URL_BASE @"http://linker.demo.evebit.com/index.php/ap/api/"

/*!
 *  获取推荐城市列表
 */
#define URL_SUB_GETCITY [URL_BASE stringByAppendingString:@"getcity"]

/*!
 *  获取主界面列表信息
 
 参数:‘city_id’ (即城市ID)
 */
#define URL_SUB_GETCATEGORY [URL_BASE stringByAppendingString:@"getcategory"]

/*!
 *  注册
 */
#define URL_SUB_REGISTER [URL_BASE stringByAppendingString:@"apiregister"]

/*!
 *  登录
 */
#define URL_SUB_LOGIN [URL_BASE stringByAppendingString:@"apilogin"]


#endif
