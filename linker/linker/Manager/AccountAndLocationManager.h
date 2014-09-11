//
//  AccountAndLocationManager.h
//  linker
//
//  Created by 李迪 on 14-6-6.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCity;

@interface AccountAndLocationManager : NSObject

@property(nonatomic,assign)BOOL loginSuccess;

+ (AccountAndLocationManager *)sharedAccountAndLocationManager;
- (BOOL)checkGPSAvailable;
- (BOOL)checkNetworkAvailable;

- (MCity *)currentSelectedCity;
- (void)saveCurrentSelectedCity:(MCity *)currentSelectedCity;

- (NSString *)userName;
- (NSString *)password;
- (NSString *)userID;

- (void)saveUserName:(NSString *)userName_;
- (void)savePassword:(NSString *)password_;
- (void)saveUserID:(NSString *)userID_;
@end
