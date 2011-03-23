//
//  NSManagedObjectHelpers.m
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import "NSManagedObjectHelpers.h"

#ifndef FETCH_BATCH_SIZE
#define FETCH_BATCH_SIZE  20
#endif

@implementation NSManagedObject (NSManagedObjectHelpers)

+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
                                   predicate: (NSPredicate*)predicate
                          includeSubentities: (BOOL)includeSubentities
                                  fetchLimit: (NSUInteger)fetchLimit
                                 fetchOffset: (NSUInteger)fetchOffset
                              fetchBatchSize: (NSUInteger)fetchBatchSize
                             sortDescriptors: (NSArray*)sortDescriptors
{
    NSArray* results = nil;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: [NSEntityDescription entityForName: CLASS_NAME 
                                         inManagedObjectContext: managedObjectContext]];
    
    [fetchRequest setPredicate: predicate];
    [fetchRequest setIncludesSubentities: includeSubentities];
    [fetchRequest setFetchLimit: fetchLimit];
    [fetchRequest setFetchOffset: fetchOffset];
    [fetchRequest setFetchBatchSize: fetchBatchSize];
    [fetchRequest setSortDescriptors: sortDescriptors];
    
    NSError* error = nil;
    results = [managedObjectContext executeFetchRequest: fetchRequest error: &error];
    if ( results == nil )
    {
        KL_LOG(@"[%@]ERROR: %@", CLASS_NAME, [error localizedDescription]);
    }
    [fetchRequest release];
    
    return results;
}

+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
                             sortDescriptors: (NSArray*)sortDescriptors
{
    return [[self class] allObjectsInManagedObjectContext: managedObjectContext 
                                                predicate: nil 
                                       includeSubentities: YES 
                                               fetchLimit: 0 
                                              fetchOffset: 0 
                                           fetchBatchSize: FETCH_BATCH_SIZE 
                                          sortDescriptors: sortDescriptors];
}

+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
{
    return [[self class] allObjectsInManagedObjectContext: managedObjectContext
                                          sortDescriptors: nil];
}

@end
