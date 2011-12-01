//
//  NSDate+NSDate_KLExtensions.h
//  keylime
//
//  Created by Jesse Curry on 12/1/11.
//  Copyright (c) 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _KLDateType
{
    KLDateTypeNone,
    KLDateTypeToday,
    KLDateTypeTomorrow,
    KLDateTypeYesterday,
    KLDateTypeThisWeek,
    KLDateTypeNextWeek,
    KLDateTypeLastWeek,
    KLDateTypeThisMonth,
    KLDateTypeNextMonth,
    KLDateTypeLastMonth,
    KLDateTypeCount
} KLDateType;

@interface NSDate (KLExtensions)
- (NSDate*)dateFor: (KLDateType)dateType;
- (NSDate*)beginningOfDay;
- (NSDate*)endOfDay;
@end
