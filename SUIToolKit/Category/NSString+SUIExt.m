//
//  NSString+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/21.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "NSString+SUIExt.h"
#import <CommonCrypto/CommonDigest.h>
#import "SUIToolKitConst.h"

@implementation NSString (SUIExt)


#pragma mark - base64

- (NSString *)base64EncodedString
{
    NSData *curData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *curStr = [curData base64EncodedStringWithOptions:0];
    uLogInfo(@"base64 encoded String > %@ <  Base64Str > %@ <", self, curStr);
    return curStr;
}

- (NSString *)base64DecodedString
{
    NSData *curData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *curStr = [[NSString alloc] initWithData:curData encoding:NSUTF8StringEncoding];
    uLogInfo(@"base64 decoded String > %@ <  Base64Str > %@ <", curStr, self);
    return curStr;
}

- (NSData *)base64EncodedData
{
    NSData *curData = [self dataUsingEncoding:NSUTF8StringEncoding];
    uLogInfo(@"base64 encoded String > %@ < return NSData", self);
    return curData;
}

- (NSData *)base64DecodedData
{
    NSData *curData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    uLogInfo(@"base64 decoded String > %@ < return NSData", self);
    return curData;
}


#pragma mark - md5

- (NSString *)md5HexDigest
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *curStr = [hash lowercaseString];
    uLogInfo(@"md5 String > %@ <  Md5 > %@ <", self, curStr);
    return curStr;
}

- (NSString *)md5HexDigest16
{
    NSString *hash = [self md5HexDigest];
    NSString *curStr = [hash substringWithRange:NSMakeRange(CC_MD5_DIGEST_LENGTH/2, CC_MD5_DIGEST_LENGTH)];
    uLogInfo(@"md5_16 String > %@ <  Md5_16 > %@ <", self, curStr);
    return curStr;
}


#pragma mark - rc4

- (NSString *)rc4Key:(NSString *)aKey
{
    NSMutableArray *iS = [[NSMutableArray alloc] initWithCapacity:256];
    NSMutableArray *iK = [[NSMutableArray alloc] initWithCapacity:256];
    
    for (int i= 0; i<256; i++) {
        [iS addObject:[NSNumber numberWithInt:i]];
    }
    
    int j=1;
    
    for (short i=0; i<256; i++) {
        
        UniChar c = [aKey characterAtIndex:i%aKey.length];
        
        [iK addObject:[NSNumber numberWithChar:c]];
    }
    
    j=0;
    
    for (int i=0; i<255; i++) {
        int is = [[iS objectAtIndex:i] intValue];
        UniChar ik = (UniChar)[[iK objectAtIndex:i] charValue];
        
        j = (j + is + ik)%256;
        NSNumber *temp = [iS objectAtIndex:i];
        [iS replaceObjectAtIndex:i withObject:[iS objectAtIndex:j]];
        [iS replaceObjectAtIndex:j withObject:temp];
        
    }
    
    int i=0;
    j=0;
    
    NSString *result = self;
    
    for (short x=0; x<[self length]; x++) {
        i = (i+1)%256;
        
        int is = [[iS objectAtIndex:i] intValue];
        j = (j+is)%256;
        
        int is_i = [[iS objectAtIndex:i] intValue];
        int is_j = [[iS objectAtIndex:j] intValue];
        
        int t = (is_i+is_j) % 256;
        int iY = [[iS objectAtIndex:t] intValue];
        
        UniChar ch = (UniChar)[self characterAtIndex:x];
        UniChar ch_y = ch^iY;
        
        result = [result stringByReplacingCharactersInRange:NSMakeRange(x, 1) withString:[NSString stringWithCharacters:&ch_y length:1]];
    }
    uLogInfo(@"rc4 String > %@ <  Rc4 > %@ <", self, result);
    return result;
}

void swap(unsigned char *first, unsigned char *second)
{
    unsigned char tempVar; // make a temporary variable
    tempVar = *first;
    *first = *second;
    *second=tempVar;
}


- (NSData *)rc4DataWithKey:(NSString*)key
{
    if(self==nil)
        return nil;
    const char *ut8String=[self UTF8String];
    size_t len=strlen(ut8String);
    int j = 0;
    unsigned char s[256];
    unsigned char result[len];
    for (int i = 0; i < 256; i++)
    {
        s[i] = i;
    }
    for (int i = 0; i < 256; i++)
    {
        j = (j + s[i] + [key characterAtIndex:(i % key.length)]) % 256;
        
        swap(&s[i], &s[j]);
    }
    
    int i = j = 0;
    
    for (int y = 0; y < len; y++)
    {
        i = (i + 1) % 256;
        j = (j + s[i]) % 256;
        swap(&s[i], &s[j]);
        
        unsigned char f = ut8String[y] ^ s[ (s[i] + s[j]) % 256];
        result[y]=f;
    }
    NSData *data = [NSData dataWithBytes:result length:sizeof(unsigned char)*len];
    
    return data;
}



@end
