//
//  NSObject+NSObject_DynamicTableViewCells.h
//  keylime
//
//  Created by Jesse Curry on 11/16/11.
//  Copyright (c) 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_DynamicTableViewCells)
+ (NSString*)tableViewCellIdentifier;
+ (Class)tableViewCellClass;
+ (UITableViewCell*)tableViewCell;
@end
