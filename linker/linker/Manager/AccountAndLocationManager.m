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

#define MOKA_KEY_CITY_CURRENT_SELECTED @"city_current_selected"

@implementation AccountAndLocationManager

+ (AccountAndLocationManager *)sharedAccountAndLocationManager
{
    static AccountAndLocationManager *sharedAccountAndLocationManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountAndLocationManager = [[self alloc] init];
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

- (NSString *)currentSelectedCity
{
    return [MOKA_USERDEFAULTS objectForKey:MOKA_KEY_CITY_CURRENT_SELECTED];
}

- (void)saveCurrentSelectedCity:(NSString *)currentSelectedCity
{
    [MOKA_USERDEFAULTS setObject:currentSelectedCity forKey:MOKA_KEY_CITY_CURRENT_SELECTED];
}

@end
