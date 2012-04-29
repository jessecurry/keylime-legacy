/*
 *  KLDefines.h
 *  keylime
 *
 *  Created by Jesse Curry on 12/5/10.
 *  Copyright 2010 Jesse Curry. All rights reserved.
 *
 */

////////////////////////////////////////////////////////////////////////////////////////////////////
// Logging
#pragma mark Logging
#if DEBUG
#define KL_LOG(...) NSLog(__VA_ARGS__)
#else
#define KL_LOG(...) /* */
#endif

#define CLASS_NAME NSStringFromClass([self class])
#define METHOD_NAME __PRETTY_FUNCTION__

#define KL_TRACE KL_LOG(@"[%@]%s", CLASS_NAME, METHOD_NAME)

////////////////////////////////////////////////////////////////////////////////////////////////////
// Class Safety
#define FORCE_STRING(x)			(x ? x : @"")
#define SAFE_STRING(str)        ([str isKindOfClass: [NSString class]] ? str : nil)
#define SAFE_NUMBER(num)        ([num isKindOfClass: [NSNumber class]] ? num : nil)
#define SAFE_ARRAY(arr)         ([arr isKindOfClass: [NSArray class]] ? arr : nil)
#define SAFE_DICTIONARY(dict)   ([dict isKindOfClass: [NSDictionary class]] ? dict : nil)

//
#define NUM_TO_STRING(num)		([num isKindOfClass: [NSNumber class]] ? [num stringValue] : SAFE_STRING(num))

////////////////////////////////////////////////////////////////////////////////////////////////////
// Colors
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed: (r) green: (g) blue: (b) alpha: (a)]
#define COLOR_RGB(r,g,b) COLOR_RGBA((r)/255.0, (g)/255.0, (b)/255.0, 1.0)

////////////////////////////////////////////////////////////////////////////////////////////////////
// Unit Conversions
#define FEET_TO_METERS(x)      ((x) * 0.3048)
#define METERS_TO_FEET(x)      ((x) * 3.2808399)
#define METERS_TO_INCHES(x)    ((x) * 39.3700787)
#define INCHES_TO_METERS(x)    ((x) * 0.0254)
#define FEET_TO_INCHES(x)      ((x) * 12.0)
#define INCHES_TO_FEET(x)      ((x) * (1.0 / 12.0))

////////////////////////////////////////////////////////////////////////////////////////////////////
// Time
#define TIME_INTERVAL_SECOND        (1.0)
#define TIME_INTERVAL_MINUTE        (60.0 * TIME_INTERVAL_SECOND)
#define TIME_INTERVAL_HOUR          (60.0 * TIME_INTERVAL_MINUTE)
#define TIME_INTERVAL_DAY           (24.0 * TIME_INTERVAL_HOUR)
#define TIME_INTERVAL_WEEK          (7.0 * TIME_INTERVAL_DAY)
#define TIME_INTERVAL_MONTH         2629743.83
#define TIME_INTERVAL_YEAR          31556926.0
#define TIME_INTERVAL_DECADE        (10.0 * TIME_INTERVAL_YEAR)
#define TIME_INTERVAL_CENTURY       (100.0 * TIME_INTERVAL_YEAR)
#define TIME_INTERVAL_MILLENNIUM    (1000.0 * TIME_INTERVAL_YEAR)