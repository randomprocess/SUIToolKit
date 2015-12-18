//
//  SUINetworkConfig.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/15.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "SUINetworkConfig.h"
#import "SUIMacros.h"
#import "AFNetworking.h"

@implementation SUINetworkConfig


uSharedInstance


- (NSTimeInterval)timeoutInterval
{
    if (_timeoutInterval <= 0) {
        _timeoutInterval = 30;
    }
    return _timeoutInterval;
}


@end
