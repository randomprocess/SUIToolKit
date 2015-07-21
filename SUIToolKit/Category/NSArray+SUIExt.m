//
//  NSArray+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/21.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "NSArray+SUIExt.h"
#import "SUIToolKitConst.h"

@implementation NSArray (SUIExt)


- (NSString *)arrayToString
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *anyError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&anyError];
        if (anyError) {
            uLogError(@"array to string Error > %@ <", anyError);
            return nil;
        }
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        uLogInfo(@"array to string succeed String > %@ <", json);
        return json;
    }
    else
    {
        uLogError(@"array to string invalid Array > %@ <", self);
    }
    return nil;
}

- (NSMutableArray *)flashback
{
    if (self.count > 1)
    {
        NSEnumerator *enumer = [self reverseObjectEnumerator];
        return [[NSMutableArray alloc] initWithArray:[enumer allObjects]];
    }
    uLogInfo(@"array flashback Array.count == 0");
    return [[NSMutableArray alloc] initWithArray:self];
}


@end
