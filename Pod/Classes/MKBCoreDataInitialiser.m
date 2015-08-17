//
//  MKBCoreDataInitialiser.m
//  Mark Bridges
//
//  Created by Mark Bridges on 27/01/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import "MKBCoreDataInitialiser.h"
#import <CoreData/CoreData.h>

static NSString *DBNameAndExtension = @"db.sqlite";

@implementation MKBCoreDataInitialiser

+ (NSManagedObjectContext *)createContextWithModelAndStoreCoordinatorWithError:(NSError *__autoreleasing *)error
{
    return [self createModelAndStoreCoordinatorWithStoreType:NSSQLiteStoreType error:error];
}

+ (NSManagedObjectContext *)createContextWithInMemoryModelAndStoreCoordinatorWithError:(NSError *__autoreleasing *)error
{
    return [self createModelAndStoreCoordinatorWithStoreType:NSInMemoryStoreType error:error];
}

+ (NSManagedObjectContext *)createModelAndStoreCoordinatorWithStoreType:(NSString *)storeType error:(NSError *__autoreleasing *)error
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    NSManagedObjectModel *mom = nil;
    mom = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    [context setPersistentStoreCoordinator:psc];
    
    context.undoManager = [[NSUndoManager alloc]init];
    
    NSPersistentStoreCoordinator *coordinator = nil;
    coordinator = psc;
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @(YES),
                              NSInferMappingModelAutomaticallyOption : @(YES)
                              };
    
    NSPersistentStore *store;
    store = [coordinator addPersistentStoreWithType:storeType
                                      configuration:nil
                                                URL:[self storeURL]
                                            options:options
                                              error:error];
    return context;
}

+ (NSURL *)storeURL
{
    NSURL *storeURL = [self applicationDocumentsDirectory];
    storeURL = [storeURL URLByAppendingPathComponent:DBNameAndExtension];
    
    return storeURL;
}

#pragma mark - Application's Documents directory

+ (NSURL *)applicationDocumentsDirectory
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSAllDomainsMask] lastObject];
    
    return url;
}

@end
