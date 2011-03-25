//
//  NSStringNSNullHelper.h
//  ThingsToDo
//
//  Created by Jesse Curry on 7/12/10.
//  Copyright 2010 St. Pete Times. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString ( NSNullHelper )
/**
 Checks if value is an NSString
 
 
 
 @param     value the suspected NSString

 @returns   an NSString or nil
 */
+ (NSString*)safeStringWithValue: (id)value;
@end
