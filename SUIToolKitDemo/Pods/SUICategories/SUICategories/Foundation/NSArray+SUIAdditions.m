//
//  NSArray+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/10.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "NSArray+SUIAdditions.h"
#import "SUIMacros.h"

@implementation NSArray (SUIAdditions)


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
            uLogError(@"array to string Error ⤭ %@ ⤪", anyError);
            return nil;
        }
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    } else {
        uLogError(@"array to string invalid Array ⤭ %@ ⤪", self);
    }
    return nil;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Random
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Random

- (id)sui_randomObject
{
    if (self.count == 0) return nil;
    
    NSInteger curIdx = gRandomInRange(0, self.count-1);
    id curObj = self[curIdx];
    return curObj;
}

- (NSArray *)sui_shuffledArray
{
    if (self.count == 0) return @[];
    
    NSMutableArray *curAry = [self mutableCopy];
    for (NSInteger idx = self.count - 1; idx > 0; idx--) {
        [curAry exchangeObjectAtIndex:arc4random_uniform((u_int32_t)idx + 1) withObjectAtIndex:idx];
    }
    return curAry;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Reverse
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Reverse

- (NSArray *)sui_reverseObject
{
    if (self.count == 0) return @[];
    
    NSEnumerator *curEnumer = [self reverseObjectEnumerator];
    NSArray *curAry = [[NSMutableArray alloc] initWithArray:[curEnumer allObjects]];
    return curAry;
}


@end
