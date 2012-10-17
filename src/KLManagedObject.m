//
//  KLManagedObject.m
//  keylime
//
//  Created by Jesse Curry on 10/17/12.
//  Copyright (c) 2012 Jesse Curry. All rights reserved.
//

#import "KLManagedObject.h"

#import "HTTPStatusCodes.h"


static NSManagedObjectContext* _defaultManagedObjectContext = nil;

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KLManagedObject
@dynamic databaseId;
@dynamic isActive;
@dynamic dirty;

#pragma mark -
#pragma mark Fetching
+ (NSFetchRequest*)fetchRequestWithSortDescriptors: (NSArray*)sortDescriptors
										 predicate: (NSPredicate*)predicate
							inManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription entityForName: NSStringFromClass([self class])
											  inManagedObjectContext: managedObjectContext];
	[fetchRequest setEntity: entity];
	[fetchRequest setFetchBatchSize: FETCH_BATCH_SIZE];
	[fetchRequest setSortDescriptors: sortDescriptors];
	[fetchRequest setPredicate: predicate];
	
	return fetchRequest;
}

+ (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest: (NSFetchRequest*)fetchRequest
													 sectionNameKeyPath: (NSString*)sectionNameKeyPath
															  cacheName: (NSString*)cacheName
												 inManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
{
	NSFetchedResultsController* frc =
	[[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest
										managedObjectContext: managedObjectContext
										  sectionNameKeyPath: sectionNameKeyPath
												   cacheName: cacheName];
    
	return frc;
}

#pragma mark -
+ (id)objectInManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
{
    id object = nil;
    
    NSString* const kClassName = NSStringFromClass([self class]);
    
    // Create a new object
    object = [NSEntityDescription insertNewObjectForEntityForName: kClassName
                                           inManagedObjectContext: managedObjectContext];
    
    return object;
}

+ (void)setDefaultManagedObjectContext: (NSManagedObjectContext*)moc
{
    if ( moc != _defaultManagedObjectContext )
    {
        _defaultManagedObjectContext = moc;
    }
}

+ (id)objectInDefaultManagedObjectContext
{
    NSManagedObjectContext* moc = _defaultManagedObjectContext;
    
    return [[self class] objectInManagedObjectContext: moc];
}

+ (id)objectWithId: (id)objectId inManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
{
    id object = nil;
    
    NSNumber* numericObjectId = SAFE_NUMBER(objectId);
    if ( numericObjectId == nil )
    {
        NSString* objectIdString = SAFE_STRING(objectId);
        if ( objectIdString )
        {
            numericObjectId = [NSNumber numberWithInt: [objectIdString intValue]];
        }
    }
    
    if ( numericObjectId )
    {
        NSString* const kClassName = NSStringFromClass([self class]);
		
        // Create a fetch request to check for an existing object with this id
		static NSPredicate* numericDatabaseIdPredicate = nil;
        if ( numericDatabaseIdPredicate == nil )
        {
            numericDatabaseIdPredicate = [NSPredicate predicateWithFormat: @"databaseId == $DATABASE_ID"];
        }
        
        NSEntityDescription* entityDescription = [NSEntityDescription entityForName: kClassName
                                                             inManagedObjectContext: managedObjectContext];
        // Create a fetch request
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity: entityDescription];
        NSPredicate* localPredicate = [numericDatabaseIdPredicate predicateWithSubstitutionVariables:
                                       [NSDictionary dictionaryWithObject: numericObjectId
                                                                   forKey: @"DATABASE_ID"]];
        [fetchRequest setPredicate: localPredicate];
        [fetchRequest setFetchLimit: 1]; // JLC: should improve performance, hopefully it doesn't bite us later.
        
        NSError* fetchError;
        NSArray* array = [managedObjectContext executeFetchRequest: fetchRequest
                                                             error: &fetchError];
        if ( array == nil )
        {
            KL_LOG( @"[%@]ERROR - %@", CLASS_NAME, [fetchError localizedDescription] );
        }
        else if ( [array count] == 0 )
        {
            // Create a new object
            object = [NSEntityDescription insertNewObjectForEntityForName: kClassName
												   inManagedObjectContext: managedObjectContext];
            [object setDatabaseId: numericObjectId];
        }
        else
        {
            NSAssert( [array count] == 1, @"Duplicate database ids found in database." );
            object = [array lastObject];
        }
    }
    
    return object;
}

+ (id)objectWithDictionary: (NSDictionary*)dictionary
	inManagedObjectContext: (NSManagedObjectContext*)managedObjectContext
{
    NSNumber* databaseId = SAFE_NUMBER([dictionary objectForKey: @"id"]);
    
    id object = [[self class] objectWithId: databaseId
					inManagedObjectContext: managedObjectContext];
    
    return object;
}

#pragma mark -
#pragma mark Serialization
- (NSDictionary*)dictionaryRepresentationWithId: (BOOL)withId
{
	NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
	
	if ( withId )
	{
		[dictionary setValue: [NSNumber numberWithInt: 0]
					  forKey: @"id"];
	}
	
	return dictionary;
}

- (NSData*)jsonDataWithId: (BOOL)withId
{
    NSDictionary* objectDictionary = [self dictionaryRepresentationWithId: withId];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject: objectDictionary
                                                       options: 0
                                                         error: &error];
    if ( error )
    {
        KL_LOG(@"[%@]Error: %@", CLASS_NAME, [error localizedDescription]);
    }
    
    return jsonData;
}

#pragma mark -
#pragma mark Helpers
// Helpers
+ (NSString*)stringFromDate: (NSDate*)date
{
	if (!date)
		return nil;
	
	static NSDateFormatter* _outputDateFormatter = nil;
	if ( _outputDateFormatter == nil )
	{
        _outputDateFormatter = [[NSDateFormatter alloc] init];
        [_outputDateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
	}
	
	return [_outputDateFormatter stringFromDate: date];
}

- (NSString*)stringFromDate: (NSDate*)date
{
	return [[self class] stringFromDate: date];
}

+ (NSDate*)dateFromString: (NSString*)dateString
{
	if (!dateString)
        return nil;
    
    if ( [dateString hasSuffix: @"Z"] )
    {
        dateString = [[dateString substringToIndex: (dateString.length-1)]
                      stringByAppendingString: @"-0000"];
    }
    
    //////////////////////////////////////////////////////////////
    static NSDateFormatter* _inputDateFormatter = nil;
    if ( _inputDateFormatter == nil )
    {
        _inputDateFormatter = [[NSDateFormatter alloc] init];
        [_inputDateFormatter setDateFormat: @"yyyy/MM/dd HH:mm:ss Z"];
    }
    
    return [_inputDateFormatter dateFromString: dateString];
}

- (NSDate*)dateFromString: (NSString*)dateString
{
	return [[self class] dateFromString: dateString];
}

- (void)softDeleteObject
{
	self.isActive = [NSNumber numberWithBool: NO];
	self.dirty = [NSNumber numberWithBool: YES];
}

#pragma mark -
+ (NSPredicate*)andPredicateForActiveEntities: (NSPredicate*)predicate
{
	NSPredicate* compoundPredicate = nil;
	NSPredicate* activePredictate = [NSPredicate predicateWithFormat: @"isActive == YES"];
	
    // The array order here is important, if predicate is nil, this is an array with one object.
    compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                         [NSArray arrayWithObjects: activePredictate, predicate, nil]];
	
	
	return compoundPredicate;
}

#pragma mark -
#pragma mark WebService
+ (NSString*)objectsPath
{
    return @"/objects";
}

+ (NSString*)objectsHTTPMethod
{
    return HTTP_GET;
}

- (NSString*)objectPath
{
    return [[[self class] objectsPath] stringByAppendingFormat: @"/%d", [self.databaseId intValue]];
}

- (NSString*)objectHTTPMethod
{
    return HTTP_GET;
}

- (NSString*)createPath
{
    return [[self class] objectsPath];
}

- (NSString*)createHTTPMethod
{
    return HTTP_POST;
}

- (NSString*)updatePath
{
    return [[[self class] objectsPath] stringByAppendingFormat: @"/%d", [self.databaseId intValue]];
}

- (NSString*)updateHTTPMethod
{
    return HTTP_PUT;
}

- (NSString*)destroyPath
{
    return [[[self class] objectsPath] stringByAppendingFormat: @"/%d", [self.databaseId intValue]];
}

- (NSString*)destroyHTTPMethod
{
    return HTTP_DELETE;
}

@end
