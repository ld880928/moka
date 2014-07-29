//
//  CommonDataManager.h
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CommonDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)insertCitys:(id)citys_;
- (id)selectAllCitys;

- (void)insertCategorys:(id)categorys_;
- (id)selectCategoryByCity:(id)city_;
@end
