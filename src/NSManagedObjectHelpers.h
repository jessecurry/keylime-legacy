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
/**
 returns all objects of this class fitting the predicate
 
 this method will return an NSArray containing all of the objects
 within an NSManagedObjectContext of the class that this method is
 called on.
 
 @param     managedObjectContext the managed object context you would like to query
 @param     predicate the predicate applied to the fetch request
 @param     includeSubentities determines if subentities will be contained within the returned array
 @param     fetchLimit the maximum number of items to fetch
 @param     fetchOffset the first item you would like to return
 @param     fetchBatchSize 
 @param     sortDescriptors used to sort the results in the array
 
 @returns   NSArray of NSManagedObjects
 */
+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
                                   predicate: (NSPredicate*)predicate
                          includeSubentities: (BOOL)includeSubentities
                                  fetchLimit: (NSUInteger)fetchLimit
                                 fetchOffset: (NSUInteger)fetchOffset
                              fetchBatchSize: (NSUInteger)fetchBatchSize
                             sortDescriptors: (NSArray*)sortDescriptors;

/**
 returns all objects of this class fitting the predicate
 
 this method will return an NSArray containing all of the objects
 within an NSManagedObjectContext of the class that this method is
 called on.
 
 @param     managedObjectContext the managed object context you would like to query
 @param     predicate the predicate applied to the fetch request
 @param     sortDescriptors used to sort the results in the array
 
 @returns   NSArray of NSManagedObjects
 */
+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
                                   predicate: (NSPredicate*)predicate
                             sortDescriptors: (NSArray*)sortDescriptors;

/**
 returns all objects of this class fitting the predicate
 
 this method will return an NSArray containing all of the objects
 within an NSManagedObjectContext of the class that this method is
 called on.
 
 @param     managedObjectContext the managed object context you would like to query
 @param     sortDescriptors used to sort the results in the array
 
 @returns   NSArray of NSManagedObjects
 */
+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
                             sortDescriptors: (NSArray*)sortDescriptors;

/**
 returns all objects of this class fitting the predicate
 
 this method will return an NSArray containing all of the objects
 within an NSManagedObjectContext of the class that this method is
 called on.
 
 @param     managedObjectContext the managed object context you would like to query

 @returns   NSArray of NSManagedObjects
 */
+ (NSArray*)allObjectsInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext;
@end
