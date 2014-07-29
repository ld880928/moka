//
//  AccountAndLocationManager.m
//  linker
//
//  Created by 李迪 on 14-6-6.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "AccountAndLocationManager.h"
#import <CoreLocation/CLLocationManager.h>
#import "Reachability.h"

#define MOKA_USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define MOKA_KEY_USERNAME @"username"
#define MOKA_KEY_PASSWORD @"password"

#define MOKA_KEY_CITY_CURRENT_SELECTED @"city_current_selected"

@implementation AccountAndLocationManager

+ (AccountAndLocationManager *)sharedAccountAndLocationManager
{
    static AccountAndLocationManager *sharedAccountAndLocationManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountAndLocationManager = [[self alloc] init];
        
        //初始设置北京为默认选中的城市
        if (![sharedAccountAndLocationManager currentSelectedCity]) {
            ZCity *zCity = [[ZCity alloc] init];
            zCity.cityID = @"5";
            zCity.cityName = @"北京";
            [sharedAccountAndLocationManager saveCurrentSelectedCity:zCity];
        }
    });
    
    return sharedAccountAndLocationManager;
}

- (BOOL)checkGPSAvailable
{
    return [CLLocationManager locationServicesEnabled];
}

- (BOOL)checkNetworkAvailable
{
    Reachability *reachability = [Reachability reachabilityForLocalWiFi];
    return reachability.currentReachabilityStatus;
}

- (ZCity *)currentSelectedCity
{
    
    NSData *cityData = [MOKA_USERDEFAULTS objectForKey:MOKA_KEY_CITY_CURRENT_SELECTED];
    ZCity *city = [NSKeyedUnarchiver unarchiveObjectWithData:cityData];
    return city;
}

- (void)saveCurrentSelectedCity:(ZCity *)currentSelectedCity
{
    NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:currentSelectedCity];
    [MOKA_USERDEFAULTS setObject:cityData forKey:MOKA_KEY_CITY_CURRENT_SELECTED];
}

- (NSString *)password
{
    return [MOKA_USERDEFAULTS objectForKey:MOKA_KEY_PASSWORD];
}

- (NSString *)userName
{
    return [MOKA_USERDEFAULTS objectForKey:MOKA_KEY_USERNAME];
}

- (void)saveUserName:(NSString *)userName_
{
    [MOKA_USERDEFAULTS setObject:userName_ forKey:MOKA_KEY_USERNAME];
}

- (void)savePassword:(NSString *)password_
{
    [MOKA_USERDEFAULTS setObject:password_ forKey:MOKA_KEY_PASSWORD];
}
@end
