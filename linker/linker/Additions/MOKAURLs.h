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

#define URL_SUB_CHANGEPASSWORD [URL_BASE stringByAppendingString:@"apinewsetpwd"]

/*!
 *  获取商家列表
 */
#define URL_SUB_GETMERCHANT [URL_BASE stringByAppendingString:@"getmerchant"]


#define URL_SUB_GETSUPRISE [URL_BASE stringByAppendingString:@"getsurprise"]

#define URL_SUB_RECIVEDMOKA [URL_BASE stringByAppendingString:@"apigetcardlist"]

#define URL_SUB_SENDEDMOKA [URL_BASE stringByAppendingString:@"apisendcardlist"]

#define URL_SUB_CREATEORDER [URL_BASE stringByAppendingString:@"apicreateorder"]

#define URL_SUB_REFUNDERLIST [URL_BASE stringByAppendingString:@"apigetrefunderlist"]

#define URL_SUB_REFUNDREQUEST [URL_BASE stringByAppendingString:@"apirequestrefund"]

#endif
