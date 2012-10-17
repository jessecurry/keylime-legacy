//
//  KLManagedObject.h
//  keylime
//
//  Created by Jesse Curry on 10/17/12.
//  Copyright (c) 2012 Jesse Curry. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 NSManagedObject subclass providing some convenience methods.
 */
enum _WebServiceConnectorTags {
    WebServiceConnectorTagNone,
    WebServiceConnectorTagReadObjects,
    WebServiceConnectorTagRead,
    WebServiceConnectorTagCreate,
    WebServiceConnectorTagUpdate,
    WebServiceConnectorTagDestroy,
    WebServiceConnectorTagReadProfile,
    WebServiceConnectorTagUpdateProfile,
    WebServiceConnectorTagCount
};

#ifndef FETCH_BATCH_SIZE
#define FETCH_BATCH_SIZE    20
#endif
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface KLManagedObject : NSManagedObject
@property (nonatomic, retain) NSNumber* databaseId; // should be provided by subclasses
@property (nonatomic, retain) NSNumber*	isActive;	// should be provided by subclasses
@property (nonatomic, retain) NSNumber* dirty;		// should be provided by subclasses

// Fetching
+ (NSFetchRequest*)fetchRequestWithSortDescriptors: (NSArray*)sortDescriptors
										 predicate: (NSPredicate*)predicate
							inManagedObjectContext: (NSManagedObjectContext*)managedObjectContext;

+ (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest: (NSFetchRequest*)fetchRequest
													 sectionNameKeyPath: (NSString*)sectionNameKeyPath
															  cacheName: (NSString*)cacheName
												 inManagedObjectContext: (NSManagedObjectContext*)managedObjectContext;

+ (id)objectInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext;
+ (void)setDefaultManagedObjectContext: (NSManagedObjectContext*)moc;
+ (id)objectInDefaultManagedObjectContext;
+ (id)objectWithId: (id)objectId inManagedObjectContext: (NSManagedObjectContext*)managedObjectContext;
+ (id)objectWithDictionary: (NSDictionary*)dictionary
	inManagedObjectContext: (NSManagedObjectContext*)managedObjectContext;

- (NSDictionary*)dictionaryRepresentationWithId: (BOOL)withId;
- (NSData*)jsonDataWithId: (BOOL)withId;

// Helpers
+ (NSString*)stringFromDate: (NSDate*)date;
- (NSString*)stringFromDate: (NSDate*)date;
+ (NSDate*)dateFromString: (NSString*)string;
- (NSDate*)dateFromString: (NSString*)string;

- (void)softDeleteObject;

//
+ (NSPredicate*)andPredicateForActiveEntities: (NSPredicate*)predicate;

// Service
+ (NSString*)objectsPath;
+ (NSString*)objectsHTTPMethod;
- (NSString*)objectPath;
- (NSString*)objectHTTPMethod;
- (NSString*)createPath;
- (NSString*)createHTTPMethod;
- (NSString*)updatePath;
- (NSString*)updateHTTPMethod;
- (NSString*)destroyPath;
- (NSString*)destroyHTTPMethod;

@end

