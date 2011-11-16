//
//  NSObject+NSObject_DynamicTableViewCells.m
//  keylime
//
//  Created by Jesse Curry on 11/16/11.
//  Copyright (c) 2011 Jesse Curry. All rights reserved.
//

#import "NSObject+NSObject_DynamicTableViewCells.h"

@implementation NSObject (NSObject_DynamicTableViewCells)
+ (NSString*)tableViewCellIdentifier
{
	return	[NSString stringWithFormat: @"%@TableViewCellIdentifier", NSStringFromClass([self class])];
}

+ (Class)tableViewCellClass
{
	Class tableViewCellClass = NSClassFromString([NSString stringWithFormat: @"%@TableViewCell", 
												  NSStringFromClass([self class])]);
	
	if ( tableViewCellClass == nil )
		tableViewCellClass = [UITableViewCell class];
	
	return tableViewCellClass;
}

+ (UITableViewCell*)tableViewCell
{
    // JLC: need the reuse identifier here so cells are dequeued properly
	return [[[[[self class] tableViewCellClass] alloc] initWithStyle: UITableViewCellStyleDefault 
                                                     reuseIdentifier: [[self class] tableViewCellIdentifier]] autorelease];
}
@end
