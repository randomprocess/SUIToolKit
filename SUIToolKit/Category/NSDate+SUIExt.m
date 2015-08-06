//
//  NSDate+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/5.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "NSDate+SUIExt.h"

@implementation NSDate (SUIExt)


- (NSInteger)currAge
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    return [components year]+1;
}


- (NSString *)stringFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : format];
    return [formatter stringFromDate:self];
}


@end
