//
//  NSString+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/7.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "NSString+SUIAdditions.h"
#import <CommonCrypto/CommonDigest.h>
#import "SUIMacros.h"
#import "NSArray+SUIAdditions.h"
#import "NSDictionary+SUIAdditions.h"

@implementation NSString (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Prehash
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Prehash

- (NSData *)sui_toData
{
    if (self.length == 0) return nil;
    
    const char *curStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *curData = [NSData dataWithBytes:curStr length:self.length];
    return curData;
}

- (NSURL *)sui_toURL
{
    if (self.length == 0) return nil;
    
    NSURL *curURL = [NSURL URLWithString:self];
    if (curURL == nil) {
        curURL = [NSURL URLWithString:[self sui_URLEncoded]];
    }
    return curURL;
}

- (NSURLRequest *)sui_toURLRequest
{
    if (self.length == 0) return nil;
    
    NSURLRequest *curURLRequest = [NSURLRequest requestWithURL:self.sui_toURL];
    return curURLRequest;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Manipulation
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Manipulation

#pragma mark Formatter

+ (NSString *)sui_stringFromObject:(id)cObject
{
    NSString *curStr = nil;
    if ([cObject isKindOfClass:[NSString class]]) {
        curStr = cObject;
    } else if ([cObject isKindOfClass:[NSNumber class]]) {
        NSNumber *curNumber = cObject;
        curStr = [curNumber description];
    } else if ([cObject isKindOfClass:[NSURL class]]) {
        NSURL *curURL = cObject;
        curStr = [curURL absoluteString];
    } else if ([cObject isKindOfClass:[NSArray class]]) {
        NSArray *curAry = cObject;
        curStr = [curAry sui_toString];
    } else if ([cObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *curDict = cObject;
        curStr = [curDict sui_toString];
    } else if (self == nil) {
        uLogInfo(@"Object is nil. This may not be what you want.");
    } else {
        curStr = [cObject description];
    }
    return curStr;
}

#pragma mark Appending

- (NSString *)sui_appendingObject:(id)cObject
{
    NSString *curStr = [NSString sui_stringFromObject:cObject];
    curStr = [self sui_appendingString:curStr];
    return curStr;
}
- (NSString *)sui_appendingString:(NSString *)cString
{
    if (cString.length == 0) return self;
    
    NSString *curStr = [self stringByAppendingString:cString];
    return curStr;
}
- (NSString *)sui_appendingFormat:(NSString *)cFormat, ...
{
    va_list args;
    va_start(args, cFormat);
    NSString *curStr = [[NSString alloc] initWithFormat:cFormat arguments:args];
    va_end(args);
    curStr = [self sui_appendingString:curStr];
    return curStr;
}

#pragma mark Contains

- (BOOL)sui_containsObject:(id)cObject
{
    NSString *curStr = [NSString sui_stringFromObject:cObject];
    return [self sui_containsString:curStr];
}
- (BOOL)sui_containsString:(NSString *)cString
{
    if (cString.length == 0) return NO;

    BOOL isContains = ([self rangeOfString:cString].location != NSNotFound);
    return isContains;
}
- (BOOL)sui_isEmpty
{
    if (self == nil || [self isEqual:[NSNull null]]) return NO;
    
    if (self.length == 0) return NO;
    
    NSString *curStr = [self sui_regex:@"\\S"];
    return (curStr.length == 0);
}

#pragma mark Regex

- (NSString *)sui_regex:(NSString *)cRegex
{
    if (cRegex.length == 0) return nil;
    
    NSRange curRange = [self rangeOfString:cRegex options:NSRegularExpressionSearch];
    if (curRange.location == NSNotFound) return nil;
    
    NSString *curStr = [self substringWithRange:curRange];
    return curStr;
}

#pragma mark Delstr

- (NSString *)sui_delstrBlankInHeadTail
{
    NSString *curStr = [self sui_delstrStringInHeadTail:@" "];
    return curStr;
}
- (NSString *)sui_delstrBlankAndWrapInHeadTail
{
    NSString *curBlank = @" ";
    NSString *curWrap = @"\n";
    
    NSString *curStr = self;
    while (1) {
        if ([curStr hasPrefix:curBlank]) {
            curStr = [curStr substringFromIndex:curBlank.length];
            continue;
        } else if ([curStr hasSuffix:curBlank]) {
            curStr = [curStr substringToIndex:curStr.length-curBlank.length];
            continue;
        } else if ([curStr hasPrefix:curWrap]) {
            curStr = [curStr substringFromIndex:curWrap.length];
            continue;
        } else if ([curStr hasSuffix:curWrap]) {
            curStr = [curStr substringToIndex:curStr.length-curWrap.length];
            continue;
        } else {
            break;
        }
    }
    return curStr;
}
- (NSString *)sui_delstrStringInHeadTail:(NSString *)cString
{
    if (cString.length == 0) return self;
    
    NSString *curStr = self;
    while (1) {
        if ([curStr hasPrefix:cString]) {
            curStr = [curStr substringFromIndex:cString.length];
            continue;
        } else if ([curStr hasSuffix:cString]) {
            curStr = [curStr substringToIndex:curStr.length-cString.length];
            continue;
        } else {
            break;
        }
    }
    return curStr;
}
- (NSString *)sui_delstrWrapInHeadTail
{
    NSString *curStr = [self sui_delstrStringInHeadTail:@"\n"];
    return curStr;
}

#pragma mark Replace

- (NSString *)sui_replaceString:(NSString *)cString withString:(NSString *)cReplacement
{
    if (cString.length == 0) return self;
    
    NSString *curStr = [self stringByReplacingOccurrencesOfString:cString withString:cReplacement];
    return curStr;
}
- (NSString *)sui_replaceString:(NSString *)cString withString:(NSString *)cReplacement options:(NSStringCompareOptions)cOptions
{
    if (cString.length == 0) return self;
    
    NSString *curStr = [self stringByReplacingOccurrencesOfString:cString withString:cReplacement options:cOptions range:NSMakeRange(0, self.length)];
    return curStr;
}
- (NSString *)sui_replaceRegex:(NSString *)cRegex withString:(NSString *)cReplacement
{
    if (cRegex.length == 0) return self;

    NSString *curStr = [self stringByReplacingOccurrencesOfString:cRegex withString:cReplacement options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    return curStr;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Encoded
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Encoded

#pragma mark URL

- (NSString *)sui_URLEncoded
{
    if (self.length == 0) return nil;
    
    NSString *curStr = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return curStr;
}
- (NSString *)sui_URLDecoded
{
    if (self.length == 0) return nil;
    
    NSString *deplussed = [self stringByRemovingPercentEncoding];
    return deplussed;
}

#pragma mark Base64

- (NSString *)sui_base64Encoded
{
    if (self.length == 0) return nil;
    
    NSData *curData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *curStr = [curData base64EncodedStringWithOptions:0];
    return curStr;
}
- (NSString *)sui_base64Decoded
{
    if (self.length == 0) return nil;
    
    NSData *curData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *curStr = [[NSString alloc] initWithData:curData encoding:NSUTF8StringEncoding];
    return curStr;
}

#pragma mark SHA1 MD5 SHA224 SHA256 SHA384 SHA512

+ (NSString *)sui_stringFromDigest:(uint8_t *)cDigest length:(int)cLength
{
    NSMutableString *curHash = [[NSMutableString alloc] initWithCapacity:cLength * 2];
    for (int idx=0; idx<cLength; idx++) {
        [curHash appendFormat:@"%02x", (int)cDigest[idx]];
    }
    return [curHash copy];
}

- (NSString *)sui_md5Digest
{
    if (self.length == 0) return nil;
    
    NSData *curData = [self sui_toData];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(curData.bytes, (CC_LONG)curData.length, digest);
    NSString *curStr = [NSString sui_stringFromDigest:digest length:CC_MD5_DIGEST_LENGTH];
    return curStr;
}
- (NSString *)sui_HMACDigestWithKey:(NSString *)cKey algorithm:(CCHmacAlgorithm)cAlgorithm
{
    if (cKey.length == 0 || self.length == 0) return nil;
    
    const char *curKey = [cKey cStringUsingEncoding:NSASCIIStringEncoding];
    const char *curData = [self cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSUInteger length = 0;
    switch (cAlgorithm) {
        case kCCHmacAlgSHA1:
            length = CC_SHA1_DIGEST_LENGTH;
            break;
        case kCCHmacAlgMD5:
            length = CC_MD5_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA224:
            length = CC_SHA224_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA256:
            length = CC_SHA256_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA384:
            length = CC_SHA384_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA512:
            length = CC_SHA512_DIGEST_LENGTH;
            break;
        default:
            uLogError(@"This should not occur");
            break;
    }
    
    if (length == 0) return nil;
    
    unsigned char *digest = malloc(length);
    CCHmac(cAlgorithm, curKey, strlen(curKey), curData, strlen(curData), digest);
    
    NSMutableString *curString = [[NSMutableString alloc] initWithCapacity:length * 2];
    for (NSUInteger i = 0; i < length; i++) {
        [curString appendFormat:@"%02lx", (unsigned long)digest[i]];
    }
    
    free(digest);
    return curString;
}

#pragma mark Rc4

- (NSData *)sui_rc4WithKey:(NSString *)cKey
{
    if (self.length == 0) return nil;
    
    const char *ut8String = [self UTF8String];
    size_t len = strlen(ut8String);
    int j = 0;
    unsigned char s[256];
    unsigned char result[len];
    for (int i = 0; i < 256; i++)
    {
        s[i] = i;
    }
    for (int i = 0; i < 256; i++)
    {
        j = (j + s[i] + [cKey characterAtIndex:(i % cKey.length)]) % 256;
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
    
    NSData *curData = [NSData dataWithBytes:result length:sizeof(unsigned char)*len];
    return curData;
}

void swap(unsigned char *first, unsigned char *second)
{
    unsigned char tempVar; // make a temporary variable
    tempVar = *first;
    *first = *second;
    *second=tempVar;
}


@end
