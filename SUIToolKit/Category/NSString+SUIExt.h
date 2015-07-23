//
//  NSString+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/21.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SUIExt)


#pragma mark - URL

- (NSString *)URLEncoded;
- (NSString *)URLDecoded;


#pragma mark - Base64

- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64EncodedData;
- (NSData *)base64DecodedData;


#pragma mark - Md5

- (NSString *)md5HexDigest; // 32
- (NSString *)md5HexDigest16; // 16


#pragma mark - Rc4

- (NSString *)rc4Key:(NSString *)aKey;
- (NSData *)rc4DataWithKey:(NSString*)key;



#pragma mark - Remove Spaces & Wrap

- (NSString *)removeTrailingSpaces;
- (NSString *)removeTrailingWrap;
- (NSString *)removeTrailingSpacesAndWrap;
- (NSString *)removeContinuousWrap;


@end
