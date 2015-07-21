//
//  NSData+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/21.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "NSData+SUIExt.h"
#import "SUIToolKitConst.h"

@implementation NSData (SUIExt)


- (NSString *)base64EncodedString
{
    NSString *curStr = [self base64EncodedStringWithOptions:0];
    uLogInfo(@"base64 encoded Base64Str > %@ <", curStr);
    return curStr;
}

- (NSString *)base64DecodedString
{
    NSString *curStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    uLogInfo(@"base64 decoded String > %@ <", curStr);
    return curStr;
}

- (NSData *)base64EncodedData
{
    return [self base64EncodedDataWithOptions:0];
}

- (NSData *)base64DecodedData
{
    return [[NSData alloc] initWithBase64EncodedData:self options:0];
}


@end
