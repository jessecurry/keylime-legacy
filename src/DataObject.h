/*
 *  DataObject.h
 *  keylime
 *
 *  Created by Jesse Curry on 12/22/10.
 *  Copyright 2010 Jesse Curry. All rights reserved.
 *
 */

@protocol DataObject <NSObject>
// TableView Cells
+ (NSString*)tableViewCellIdentifier;
+ (Class)tableViewCellClass;
+ (UITableViewCell*)tableViewCell;
@end