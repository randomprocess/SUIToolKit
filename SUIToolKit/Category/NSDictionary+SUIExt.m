//
//  NSDictionary+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/21.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "NSDictionary+SUIExt.h"
#import "SUIToolKitConst.h"

@implementation NSDictionary (SUIExt)


- (NSString *)dictToString
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *anyError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&anyError];
        if (anyError) {
            uLogError(@"dict to string Error ⤭ %@ ⤪", anyError);
            return nil;
        }
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        uLogInfo(@"dict to string succeed String ⤭ %@ ⤪", json);
        return json;
    }
    else
    {
        uLogError(@"dict to string invalid Dict ⤭ %@ ⤪", self);
    }
    return nil;
}

- (NSString *)stringForKey:(id)key
{
    id object = [self objectForKey:key];
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    return @"";
}


@end
