//
//  NSNumberNSNullHelper.h
//  PourHouse
//
//  Created by Jesse Curry on 12/5/10.
//  Copyright 2010 Circonda, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNumber ( NSNullHelper )

/**
 Makes sure that the passed object is an NSNumber.
 
 Checks if value is an NSNumber, if so value is returned, if not nil is returned.
 This method is useful when using structures returned from the JSON parser, in
 the event that a null value is encountered the structure will have an NSNull in
 place of the NSNumber.
 
 @param     value the object you beleive to be an NSNumber.

 @returns   an NSNumber or nil.
 */
+ (NSNumber*)safeNumberWithValue: (id)value;
@end
