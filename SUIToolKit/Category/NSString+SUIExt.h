//
//  NSString+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/21.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SUIExt)


#pragma mark - base64

- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64EncodedData;
- (NSData *)base64DecodedData;


#pragma mark - md5

- (NSString *)md5HexDigest; // 32
- (NSString *)md5HexDigest16; // 16


#pragma mark - rc4

- (NSString *)rc4Key:(NSString *)aKey;
- (NSData *)rc4DataWithKey:(NSString*)key;


@end
