//
//  SUIBaseConfig.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseConfig.h"
#import "SUIToolKitConst.h"

@implementation SUIBaseConfig


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Shared
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (instancetype)sharedConfig
{
    static SUIBaseConfig *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Http
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (NSString *)httpMethod
{
    if (_httpMethod == nil)
    {
        _httpMethod = @"POST";
    }
    return _httpMethod;
}

- (NSString *)httpHost
{
    if (_httpHost == nil)
    {
        uAssert(NO, @"should set httpHost");
    }
    return _httpHost;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  VC
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (UIColor *)backgroundColor
{
    if (_backgroundColor == nil)
    {
        return [UIColor whiteColor];
    }
    return _backgroundColor;
}

- (UIColor *)separatorColor
{
    if (_separatorColor == nil)
    {
        return gRGB(20, 20, 20);
    }
    return _separatorColor;
}

- (NSString *)separatorInset
{
    if (_separatorInset == nil)
    {
        return @"{0,10,0,0}";
    }
    return _separatorInset;
}

- (NSInteger)pageSize
{
    if (_pageSize == 0)
    {
        _pageSize = 20;
    }
    return _pageSize;
}


@end
