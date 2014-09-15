//
//  AppDelegate.m
//  linker
//
//  Created by 李迪 on 14-5-12.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "AppDelegate.h"
#import "UMessage.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "PartnerConfig.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"EQljf6vwuZU0tj65tizvV6FA"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //set AppKey and AppSecret
    [UMessage startWithAppkey:@"5406df0afd98c589f30012ba" launchOptions:launchOptions];
    
    //register remoteNotification types
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
    [UMessage setLogEnabled:YES];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Alipay
//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parse:url application:application];
	return YES;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    

	if (result)
    {
		
		if (result.statusCode == 9000)
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotification object:result];
            
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(AlipayPubKey);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改

            }
            
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}


@end
