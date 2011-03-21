//
//  NSNumberNSNullHelper.h
//  PourHouse
//
//  Created by Jesse Curry on 12/5/10.
//  Copyright 2010 Circonda, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNumber ( NSNullHelper )
+ (NSNumber*)safeNumberWithValue: (id)value;
@end
