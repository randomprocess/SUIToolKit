//
//  NSNumber+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/10.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "NSNumber+SUIAdditions.h"

@implementation NSNumber (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Prehash
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Prehash

- (NSDate *)sui_toDate
{
    double curTime = [self doubleValue];
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:curTime];
    return curDate;
}


@end
