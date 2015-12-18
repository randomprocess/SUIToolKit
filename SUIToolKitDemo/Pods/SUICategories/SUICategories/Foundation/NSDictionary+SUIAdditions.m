//
//  NSDictionary+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/10.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "NSDictionary+SUIAdditions.h"
#import "NSString+SUIAdditions.h"
#import "SUIMacros.h"

@implementation NSDictionary (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Prehash
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Prehash

- (NSString *)sui_toString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *anyError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&anyError];
        if (anyError) {
            uLogError(@"dict to string Error ⤭ %@ ⤪", anyError);
            return nil;
        }
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    } else {
        uLogError(@"dict to string invalid Array ⤭ %@ ⤪", self);
    }
    return nil;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Accessing
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Accessing

- (id)sui_safeObjectForKey:(id)cKey
{
    id curObj = [self objectForKey:cKey];
    
    if (curObj == nil || curObj == [NSNull null]) return nil;
    
    return curObj;
}

- (NSString *)sui_safeStringForKey:(id)cKey
{
    id curObj = [self objectForKey:cKey];
    
    if (curObj == nil || curObj == [NSNull null]) return nil;
    
    NSString *curStr = [NSString sui_stringFromObject:curObj];
    return curStr;
}


@end
