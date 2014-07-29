//
//  MCity.h
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCity : NSManagedObject

@property (nonatomic, retain) NSString * cityID;
@property (nonatomic, retain) NSString * cityName;

@end
