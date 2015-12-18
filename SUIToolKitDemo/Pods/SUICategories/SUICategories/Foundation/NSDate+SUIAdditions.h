//
//  NSDate+SUIAdditions.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/10.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Component
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Component

@property (readonly) NSInteger sui_year;
@property (readonly) NSInteger sui_month;
@property (readonly) NSInteger sui_day;
@property (readonly) NSInteger sui_hour;
@property (readonly) NSInteger sui_minute;
@property (readonly) NSInteger sui_second;
@property (readonly) NSInteger sui_age;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Formatter
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Formatter

+ (nullable NSDate *)sui_dateFromISO8601String:(NSString *)cISO8601String;
- (NSString *)sui_ISO8601String;

- (NSString *)sui_stringFormat:(NSString *)cFormat;


@end

NS_ASSUME_NONNULL_END
