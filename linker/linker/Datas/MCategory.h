//
//  MCategory.h
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryID;
@property (nonatomic, retain) NSString * categoryIcon;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * cityID;

@end
