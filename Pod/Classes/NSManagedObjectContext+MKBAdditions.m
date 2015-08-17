//
//  NSManagedObjectContext+JSAdditions.m
//  Mark Bridges
//
//  Created by Mark Bridges on 27/01/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import "NSManagedObjectContext+MKBAdditions.h"

@implementation NSManagedObjectContext (MKBAdditions)

- (id)insertEntityNamed:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error
{
    return [self fetchEntitiesNamed:entityName withPredicate:nil error:error];
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error
{
    return [self fetchEntitiesNamed:entityName withPredicate:predicate sortedByKey:nil withFetchLimit:0 withPropertiesToFetch:nil error:error];
}

- (id)fetchSingleEntityNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error
{
    return [self fetchSingleEntityNamed:entityName withPredicate:nil error:error];
}

- (id)fetchSingleEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error
{
    NSArray *results = [self fetchEntitiesNamed:entityName withPredicate:predicate sortedByKey:nil withFetchLimit:1 withPropertiesToFetch:nil error:error];
    return results.lastObject;
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate withFetchLimit:(NSUInteger)limit error:(NSError *__autoreleasing *)error
{
    NSArray *results = [self fetchEntitiesNamed:entityName withPredicate:predicate sortedByKey:nil withFetchLimit:limit withPropertiesToFetch:nil error:error];
    return results;
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate withFetchLimit:(NSUInteger)limit withPropertiesToFetch:(NSArray *)properties error:(NSError *__autoreleasing *)error
{
    NSArray *results = [self fetchEntitiesNamed:entityName withPredicate:predicate sortedByKey:nil withFetchLimit:limit withPropertiesToFetch:properties error:error];
    return results;
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName sortedByKey:(NSString *)sortKey error:(NSError *__autoreleasing *)error
{
    return [self fetchEntitiesNamed:entityName withPredicate:nil sortedByKey:sortKey withFetchLimit:0 withPropertiesToFetch:nil error:error];
}

- (void)deleteAllObjects:(NSString *)entityDescription error:(NSError *__autoreleasing *)error
{
    for (NSManagedObject *anObject in [self fetchEntitiesNamed:entityDescription error:error])
    {
        [self deleteObject:anObject];
    }
}

- (void)deleteAllObjects:(NSString *)entityDescription withPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error
{
    for (NSManagedObject *anObject in[self fetchEntitiesNamed:entityDescription withPredicate:predicate error:error])
    {
        [self deleteObject:anObject];
    }
}

- (NSUInteger)countOfEntitiesNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error
{
    return [self countOfEntitiesNamed:entityName withPredicate:nil error:error];
}

- (NSUInteger)countOfEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error
{
    NSFetchRequest *fetchRequest = [self fetchRequestForEntitiesNamed:entityName withPredicate:predicate sortedByKey:nil withFetchLimit:0 withPropertiesToFetch:nil];
    NSUInteger count = [self countForFetchRequest:fetchRequest error:error];
    
    return count;
}

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortedByKey:(NSString *)sortKey withFetchLimit:(NSUInteger)fetchLimit withPropertiesToFetch:(NSArray *)properties error:(NSError *__autoreleasing *)error
{
    NSFetchRequest *fetchRequest = [self fetchRequestForEntitiesNamed:entityName withPredicate:predicate sortedByKey:sortKey withFetchLimit:fetchLimit withPropertiesToFetch:properties];
    
    return [self executeFetchRequest:fetchRequest error:error];
}

- (NSFetchRequest*)fetchRequestForEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortedByKey:(NSString *)sortKey withFetchLimit:(NSUInteger)fetchLimit withPropertiesToFetch:(NSArray *)properties
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    if (fetchLimit > 0)
    {
        [fetchRequest setFetchLimit:fetchLimit];
    }
    
    if (sortKey)
    {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    if (properties.count > 0)
    {
        fetchRequest.propertiesToFetch = properties;
    }
    
    return fetchRequest;
}


@end
