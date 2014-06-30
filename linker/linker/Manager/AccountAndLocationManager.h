//
//  AccountAndLocationManager.h
//  linker
//
//  Created by 李迪 on 14-6-6.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountAndLocationManager : NSObject

@property(nonatomic,assign)BOOL loginSuccess;

+ (AccountAndLocationManager *)sharedAccountAndLocationManager;
- (BOOL)checkGPSAvailable;
- (BOOL)checkNetworkAvailable;

- (NSString *)currentSelectedCity;
- (void)saveCurrentSelectedCity:(NSString *)currentSelectedCity;

- (NSString *)userName;
- (NSString *)password;
- (void)saveUserName:(NSString *)userName_;
- (void)savePassword:(NSString *)password_;
@end