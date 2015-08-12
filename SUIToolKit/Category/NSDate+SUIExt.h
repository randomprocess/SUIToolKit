//
//  NSDate+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/5.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SUIExt)



#pragma mark - Data component

- (NSInteger)currYear;
- (NSInteger)currMonth;
- (NSInteger)currDay;
- (NSInteger)currHour;
- (NSInteger)currMinute;
- (NSInteger)currSecond;
- (NSInteger)currAge;




#pragma mark - Date formate

- (NSString *)stringFormat:(NSString *)format;


@end
