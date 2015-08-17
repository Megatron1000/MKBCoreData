//
//  MKBCoreDataInitialiser.h
//  Mark Bridges
//
//  Created by Mark Bridges on 27/01/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKBCoreDataInitialiser : NSObject

+ (NSManagedObjectContext *)createContextWithModelAndStoreCoordinatorWithError:(NSError *__autoreleasing *)error;
+ (NSManagedObjectContext *)createContextWithInMemoryModelAndStoreCoordinatorWithError:(NSError *__autoreleasing *)error;

@end
