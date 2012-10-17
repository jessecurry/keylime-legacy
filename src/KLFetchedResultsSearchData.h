//
//  KLFetchedResultsSearchData.h
//  ClientConnect
//
//  Created by Jesse Curry on 1/10/11.
//  Copyright 2011 Haneke Design. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class is kinda stupid now. I need to find a way to guarantee that there is one
// spot for a substitution variable named '$SEARCH_STRING', and work to better replicate
// the behavior of NSArray.

// TODO: make this class better.
extern NSString* const kSearchStringKey;
@interface KLFetchedResultsSearchData : NSObject 
{
	NSString*		searchString;
	NSArray*		dataSource;
	
	BOOL			dirty;
	
	NSPredicate*	predicate;
	NSPredicate*	localPredicate;
	
	NSArray*		searchResults;
}
@property (nonatomic, strong) NSPredicate* predicate;
@property (unsafe_unretained, nonatomic, readonly) NSArray* searchResults;

+ (id)searchDataWithPredicate: (NSPredicate*)predicate;

//
- (void)updateSearchString: (NSString*)searchString;
- (void)updateDataSource: (NSArray*)dataSource;

- (NSUInteger)count;
- (id)objectAtIndex: (NSUInteger)index;

@end
