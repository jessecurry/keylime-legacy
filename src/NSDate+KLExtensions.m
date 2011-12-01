//
//  NSDate+NSDate_KLExtensions.m
//  keylime
//
//  Created by Jesse Curry on 12/1/11.
//  Copyright (c) 2011 Jesse Curry. All rights reserved.
//

#import "NSDate+KLExtensions.h"

@implementation NSDate (KLExtensions)

- (NSDate*)dateFor: (KLDateType)dateType 
{
    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* comps =
        [calendar components: (NSEraCalendarUnit | NSYearCalendarUnit 
                               | NSMonthCalendarUnit | NSWeekCalendarUnit 
                               | NSWeekdayCalendarUnit | NSDayCalendarUnit 
                               | NSTimeZoneCalendarUnit)
                    fromDate: self];

    if ( dateType == KLDateTypeToday )
    {
        // no-op
    }
    else if ( dateType == KLDateTypeTomorrow )
    {
        comps.day++;
    }
    else if ( dateType == KLDateTypeYesterday )
    {
        comps.day--;
    }
    else if ( dateType == KLDateTypeThisWeek )
    {
        comps.weekday = 1;
    }
    else if ( dateType == KLDateTypeNextWeek )
    {
        comps.weekday = 1;
        comps.week++;
    }
    else if ( dateType == KLDateTypeLastWeek )
    {
        comps.weekday = 1;
        comps.week--;
    }
    else if ( dateType == KLDateTypeThisMonth )
    {
        comps.day = 1;
    }
    else if ( dateType == KLDateTypeNextMonth )
    {
        comps.day = 1;
        comps.month++;
    }
    else if ( dateType == KLDateTypeLastMonth )
    {
        comps.day = 1;
        comps.month--;
    }
    else
    {
        return nil;
    }

    return [calendar dateFromComponents: comps];
}

- (NSDate*)beginningOfDay
{
    return [self dateFor: KLDateTypeToday];
}

- (NSDate*)endOfDay
{
    NSDate* tomorrow = [self dateFor: KLDateTypeTomorrow];
    NSDate* endOfDay = [tomorrow dateByAddingTimeInterval: -1.0];
    
    return endOfDay;
}

@end
