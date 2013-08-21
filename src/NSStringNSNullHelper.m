//
//  NSStringNSNullHelper.m
//  ThingsToDo
//
//  Created by Jesse Curry on 7/12/10.
//  Copyright 2010 keylime. All rights reserved.
//

#import "NSStringNSNullHelper.h"


@implementation NSString ( NSNullHelper )
+ (NSString*)safeStringWithValue: (id)value
{
	if ( [value isKindOfClass: [NSString class]] )
		return value;
	else
		return nil;
}

@end
