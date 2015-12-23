//
//  SUIAlbumMD.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/21.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIAlbumMD.h"
#import "MJExtension.h"
#import "SUIToolKit.h"

@implementation SUIAlbumMD


+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"artists" : [SUIArtistMD class]};
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"aId"]) {
        return @"id";
    }
    return propertyName;
}

+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"coverImage"];
}



+ (void)initialize
{
    [self removePropertyWithColumnName:@"coverImage"];
}

@end


@implementation SUIArtistMD


+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"tId"]) {
        return @"id";
    }
    return propertyName;
}

+ (NSString*)getPrimaryKey
{
    return @"tId";
}


@end


