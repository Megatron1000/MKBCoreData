//
//  NSManagedObjectContext+JSAdditions.h
//  Mark Bridges
//
//  Created by Mark Bridges on 27/01/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (MKBAdditions)

- (id)insertEntityNamed:(NSString *)entityName;

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error;

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error;

- (id)fetchSingleEntityNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error;

- (id)fetchSingleEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error;

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName sortedByKey:(NSString *)sortKey error:(NSError *__autoreleasing *)error;

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate withFetchLimit:(NSUInteger)limit error:(NSError *__autoreleasing *)error;

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortedByKey:(NSString *)sortKey withFetchLimit:(NSUInteger)fetchLimit withPropertiesToFetch:(NSArray *)properties error:(NSError *__autoreleasing *)error;

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate withFetchLimit:(NSUInteger)limit withPropertiesToFetch:(NSArray *)properties error:(NSError *__autoreleasing *)error;

- (void)deleteAllObjects:(NSString *)entityDescription error:(NSError *__autoreleasing *)error;

- (void)deleteAllObjects:(NSString *)entityDescription withPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error;

- (NSUInteger)countOfEntitiesNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error;

- (NSUInteger)countOfEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error;

- (NSFetchRequest*)fetchRequestForEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortedByKey:(NSString *)sortKey withFetchLimit:(NSUInteger)fetchLimit withPropertiesToFetch:(NSArray *)properties;

@end
