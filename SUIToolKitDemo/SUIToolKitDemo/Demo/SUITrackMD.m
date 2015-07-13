//
//  SUITrackMD.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/13.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUITrackMD.h"
#import "SUIMediaMD.h"

@implementation SUITrackMD

@dynamic dlyric;
@dynamic availability;
@dynamic trackId;
@dynamic slyric;
@dynamic title;
@dynamic isdown;
@dynamic mv;
@dynamic isplay;
@dynamic medias;


+ (NSDictionary *)objectClassInArray{
    return @{@"medias":[SUIMediaMD class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"trackId": @"id"
             };
}

@end
