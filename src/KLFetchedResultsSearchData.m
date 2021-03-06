//
//  KLFetchedResultsSearchData.m
//  ClientConnect
//
//  Created by Jesse Curry on 1/10/11.
//  Copyright 2011 Haneke Design. All rights reserved.
//

#import "KLFetchedResultsSearchData.h"

NSString* const kSearchStringKey = @"SEARCH_STRING";

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface KLFetchedResultsSearchData ()
@property (nonatomic, strong) NSString*		searchString;
@property (nonatomic, strong) NSArray*		dataSource;
@property (nonatomic, strong) NSPredicate*	localPredicate;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KLFetchedResultsSearchData
@synthesize predicate;
@synthesize searchString;
@synthesize dataSource;
@synthesize localPredicate;

+ (id)searchDataWithPredicate: (NSPredicate*)predicate
{
	id sd = [[[self class] alloc] init];
	if ( sd )
	{
		[sd setPredicate: predicate];
	}
	return sd;
}

#pragma mark -
- (id)init
{
	if ( self = [super init] )
	{
		dirty = YES;
	}
	return self;
}


#pragma mark -
- (void)updateSearchString: (NSString*)theSearchString
{
	if ( ![self.searchString isEqualToString: theSearchString] )
	{
		self.searchString = theSearchString;
		NSDictionary* dict = [NSDictionary dictionaryWithObject: theSearchString 
														 forKey: kSearchStringKey];
		self.localPredicate = [self.predicate predicateWithSubstitutionVariables: dict];
		
		dirty = YES;
	}
}

- (void)updateDataSource: (NSArray*)theDataSource
{
	if ( self.dataSource != theDataSource )
	{
		self.dataSource = theDataSource;
		dirty = YES;
	}
}

#pragma mark -
- (NSUInteger)count
{
	return [self.searchResults count];
}

- (id)objectAtIndex: (NSUInteger)index
{
	return [self.searchResults objectAtIndex: index];
}

#pragma mark -
#pragma mark Properties
- (NSArray*)searchResults
{
if ( dirty )
	{
		if ( self.localPredicate )
			searchResults = [self.dataSource filteredArrayUsingPredicate: self.localPredicate];
		else
			searchResults = nil;
		
		// All clean!
		dirty = NO;
	}
	return searchResults;
}

@end
