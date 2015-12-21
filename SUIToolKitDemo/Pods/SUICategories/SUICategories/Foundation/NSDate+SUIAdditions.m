//
//  NSDate+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/10.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "NSDate+SUIAdditions.h"
#import <CoreGraphics/CoreGraphics.h>
#include <xlocale.h>
#include <time.h>
#import "SUIMacros.h"

@implementation NSDate (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Prehash
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Prehash

- (NSTimeInterval)sui_toTime
{
    return [self timeIntervalSince1970];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Component
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Component

- (NSInteger)sui_year
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSInteger curYear = [dateComponents year];
    return curYear;
}
- (NSInteger)sui_month
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self];
    NSInteger curMonth = [dateComponents month];
    return curMonth;
}
- (NSInteger)sui_day
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];
    NSInteger curDay = [dateComponents day];
    return curDay;
}
- (NSInteger)sui_hour
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self];
    NSInteger curHour = [dateComponents hour];
    return curHour;
}
- (NSInteger)sui_minute
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self];
    NSInteger curMinute = [dateComponents minute];
    return curMinute;
}
- (NSInteger)sui_second
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self];
    NSInteger curSecond = [dateComponents second];
    return curSecond;
}
- (NSInteger)sui_age
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];
    NSInteger curYear = [components year]+1;
    return curYear;
}

- (NSDate *)sui_convertToLocalTime
{
    
    
    NSTimeZone *curTimeZone = [NSTimeZone localTimeZone];
    NSInteger timeOffset = [curTimeZone secondsFromGMTForDate:self];
    NSDate *curDate = [self dateByAddingTimeInterval:timeOffset];
    return curDate;
}
- (NSDate *)sui_convertToTimeZoneWithAbbreviation:(NSString *)cAbbreviation
{
    NSTimeZone *curTimeZone = [NSTimeZone timeZoneWithAbbreviation:cAbbreviation];
    NSInteger timeOffset = [curTimeZone secondsFromGMTForDate:self];
    NSDate *curDate = [self dateByAddingTimeInterval:timeOffset];
    return curDate;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Formatter
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Format

+ (NSDate *)sui_dateFromISO8601String:(NSString *)cISO8601String
{
    if (cISO8601String.length == 0) return nil;
    
    if (kNilOrNull(cISO8601String)) return nil;
    
    const char *str = [cISO8601String cStringUsingEncoding:NSUTF8StringEncoding];
    size_t len = strlen(str);
    if (len == 0) return nil;
    
    struct tm tm;
    char newStr[25] = "";
    BOOL hasTimezone = NO;
    
    // 2014-03-30T09:13:00Z
    if (len == 20 && str[len - 1] == 'Z') {
        strncpy(newStr, str, len - 1);
    }
    
    // 2014-03-30T09:13:00-07:00
    else if (len == 25 && str[22] == ':') {
        strncpy(newStr, str, 19);
        hasTimezone = YES;
    }
    
    // 2014-03-30T09:13:00.000Z
    else if (len == 24 && str[len - 1] == 'Z') {
        strncpy(newStr, str, 19);
    }
    
    // 2014-03-30T09:13:00.000-07:00
    else if (len == 29 && str[26] == ':') {
        strncpy(newStr, str, 19);
        hasTimezone = YES;
    }
    
    // Poorly formatted timezone
    else {
        strncpy(newStr, str, len > 24 ? 24 : len);
    }
    
    // Timezone
    size_t l = strlen(newStr);
    if (hasTimezone) {
        strncpy(newStr + l, str + len - 6, 3);
        strncpy(newStr + l + 3, str + len - 2, 2);
    } else {
        strncpy(newStr + l, "+0000", 5);
    }
    
    // Add null terminator
    newStr[sizeof(newStr) - 1] = 0;
    
    if (strptime(newStr, "%FT%T%z", &tm) == NULL) {
        return nil;
    }
    
    time_t t;
    t = mktime(&tm);
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:t];
    return curDate;
}
- (NSString *)sui_ISO8601String
{
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[self timeIntervalSince1970];
    timeinfo = gmtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%SZ", timeinfo);
    
    NSString *curStr = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    return curStr;
}

- (NSString *)sui_stringFormat:(NSString *)cFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : cFormat];
    return [formatter stringFromDate:self];
}

+ (NSTimeInterval)sui_time
{
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    return curTime;
}


@end
