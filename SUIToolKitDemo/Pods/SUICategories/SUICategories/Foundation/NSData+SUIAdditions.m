//
//  NSData+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/10.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "NSData+SUIAdditions.h"

@implementation NSData (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Encoded
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Encoded

#pragma mark Base64

- (NSString *)sui_base64Encoded
{
    if (self.length == 0) return nil;
    
    NSString *curStr = [self base64EncodedStringWithOptions:0];
    return curStr;
}
- (NSString *)sui_base64Decoded
{
    if (self.length == 0) return nil;
    
    NSString *curStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return curStr;
}


@end
