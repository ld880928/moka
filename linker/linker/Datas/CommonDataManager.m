//
//  CommonDataManager.m
//  linker
//
//  Created by 李迪 on 14-7-29.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "CommonDataManager.h"

#import "MCity.h"
#import "MCategory.h"

#import "Models.h"

@implementation CommonDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Common" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Common.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.获取Documents路径
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)insertCitys:(id)citys_
{
    [self deleteAllCitys];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    for (ZCity *city in citys_) {
        MCity *mCity   = [NSEntityDescription insertNewObjectForEntityForName:@"MCity" inManagedObjectContext:context];
        mCity.cityID   = city.cityID;
        mCity.cityName = city.cityName;
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}

- (id)selectAllCitys
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MCity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (MCity *mCity in fetchedObjects) {
        ZCity *zCity = [[ZCity alloc] initWithCoreDataObject:mCity];
        [resultArray addObject:zCity];
    }
    return resultArray;
}

- (void)deleteAllCitys
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MCity" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

- (void)insertCategorys:(id)categorys_
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MCategory" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"cityID = %@",[[categorys_ objectAtIndex:0] cityID]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
    
    
    for (ZCategory *category in categorys_) {
        MCategory *mCategory   = [NSEntityDescription insertNewObjectForEntityForName:@"MCategory" inManagedObjectContext:context];
        mCategory.categoryID   = category.categoryID;
        mCategory.categoryName   = category.categoryName;
        mCategory.categoryIcon   = category.categoryIcon;
        mCategory.cityID = category.cityID;
        
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}

- (id)selectCategoryByCity:(id)city_
{
    ZCity *city = city_;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MCategory" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"cityID = %@",city.cityID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (MCategory *mCategory in fetchedObjects) {
        ZCategory *zCategory = [[ZCategory alloc] initWithCoreDataObject:mCategory];
        [resultArray addObject:zCategory];
    }
    return resultArray;
}

@end
