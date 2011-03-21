//
//  NSNumberNSNullHelper.m
//  PourHouse
//
//  Created by Jesse Curry on 12/5/10.
//  Copyright 2010 Circonda, Inc. All rights reserved.
//

#import "NSNumberNSNullHelper.h"


@implementation NSNumber ( NSNullHelper )
+ (NSNumber*)safeNumberWithValue: (id)value
{
	if ( [value isKindOfClass: [NSNumber class]] )
		return value;
	else
		return nil;
}
@end
