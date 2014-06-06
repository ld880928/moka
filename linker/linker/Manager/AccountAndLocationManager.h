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
@end
