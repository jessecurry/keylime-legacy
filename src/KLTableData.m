//
//  KLTableData.m
//  ClientConnect
//
//  Created by Jesse Curry on 2/1/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import "KLTableData.h"
#import "NSStringNSNullHelper.h"

@implementation KLTableData
- (id)init
{
	if ( self = [super init] )
	{
		sectionNames = [[NSMutableArray alloc] init];
		sectionDatum = [[NSMutableArray alloc] init];
	}
	return self;
}


#pragma mark -
- (void)addSectionName: (NSString*)sectionName withData: (NSArray*)sectionData
{
	if ( sectionName && sectionData )
	{
		[sectionNames addObject: sectionName];
		[sectionDatum addObject: sectionData];
	}
}

- (void)removeSection: (NSInteger)sectionIndex
{
	NSAssert([sectionNames count] == [sectionDatum count], @"You really messed up this time, jesse! Seriously!");
	if ( sectionIndex < [sectionNames count]
		&& sectionIndex < [sectionDatum count] )
	{
		[sectionNames removeObjectAtIndex: sectionIndex];
		[sectionDatum removeObjectAtIndex: sectionIndex];
	}
}

#pragma mark -
- (NSInteger)numberOfSections
{
	NSAssert([sectionNames count] == [sectionDatum count], @"You really messed up this time, jesse!");
	return [sectionNames count];
}

- (NSInteger)numberOfRowsInSection: (NSInteger)sectionIndex
{
	NSInteger rowCount = 0;
	
	if ( sectionIndex < [sectionDatum count] )
	{
		id sectionData = [sectionDatum objectAtIndex: sectionIndex];
		if ( [sectionData isKindOfClass: [NSArray class]] )
		{
			rowCount = [sectionData count];
		}
	}
	
	return rowCount;
}

- (NSString*)titleForSection: (NSInteger)sectionIndex
{
	NSString* title = @"";
	
	if ( sectionIndex < [sectionNames count] )
	{
		title = [NSString safeStringWithValue: [sectionNames objectAtIndex: sectionIndex]];
	}
	
	return title;
}

- (id)dataObjectForIndexPath: (NSIndexPath*)indexPath
{
	id dataObject = nil;
	
	if ( indexPath.section < [sectionDatum count] )
	{
		id sectionData = [sectionDatum objectAtIndex: indexPath.section];
		if ( [sectionData isKindOfClass: [NSArray class]]
			&& indexPath.row < [sectionData count] )
		{
			dataObject = [sectionData objectAtIndex: indexPath.row];
		}
	}
	
	return dataObject;
}

@end
