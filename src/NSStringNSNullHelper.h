//
//  NSStringNSNullHelper.h
//  ThingsToDo
//
//  Created by Jesse Curry on 7/12/10.
//  Copyright 2010 St. Pete Times. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString ( NSNullHelper ) 
+ (NSString*)safeStringWithValue: (id)value;
@end
