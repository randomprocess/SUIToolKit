//
//  SUIAlbumMD.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/6.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIAlbumMD.h"

@implementation SUIAlbumMD


+ (NSDictionary *)objectClassInArray
{
    return @{@"artists":[SUIArtistMD class]};
}


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"albumId": @"id"
             };
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"albumId:%zd \t name:%@ \t type:%@ \t cover:%@ \t num_tracks:%zd \t company:%@ \t  available:%zd \t release_date:%@", _albumId, _name, _type, _cover, _num_tracks, _company, _available, _release_date];
}

@end


@implementation SUIArtistMD


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"artistId": @"id"
             };
}

@end
