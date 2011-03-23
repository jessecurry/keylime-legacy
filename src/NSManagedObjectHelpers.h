//
//  NSManagedObjectHelpers.h
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (NSManagedObjectHelpers)
+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
                                   predicate: (NSPredicate*)predicate
                          includeSubentities: (BOOL)includeSubentities
                                  fetchLimit: (NSUInteger)fetchLimit
                                 fetchOffset: (NSUInteger)fetchOffset
                              fetchBatchSize: (NSUInteger)fetchBatchSize
                             sortDescriptors: (NSArray*)sortDescriptors;
+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
                             sortDescriptors: (NSArray*)sortDescriptors;
+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext;
@end
