//
//  SUIAlbumMD.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/6.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIAlbumMD.h"

@implementation SUIAlbumMD


+ (NSDictionary *)objectClassInArray{
    return @{@"artists":[SUIArtistMD class]};
}

@end


@implementation SUIArtistMD

@end
