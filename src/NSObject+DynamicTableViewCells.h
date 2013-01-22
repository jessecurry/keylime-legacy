//
//  NSObject+NSObject_DynamicTableViewCells.h
//  keylime
//
//  Created by Jesse Curry on 11/16/11.
//  Copyright (c) 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Category to add methods for assisting with dynamic UITableViewCells
 */
@interface NSObject (DynamicTableViewCells)
/**
 Provides a default reuse identifier for tableView cells used to display this object.
 */
+ (NSString*)tableViewCellIdentifier;
/**
 Returns the default tableViewCell class.
 */
+ (Class)tableViewCellClass;
/**
 Returns a tableViewCell using the class and reuse identifier.
 */
+ (UITableViewCell*)tableViewCell;
@end
