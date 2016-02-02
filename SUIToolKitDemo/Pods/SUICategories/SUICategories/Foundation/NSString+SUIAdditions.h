//
//  NSString+SUIAdditions.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/7.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Prehash
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Prehash

@property (nullable,readonly,copy) NSData *sui_toData;
@property (nullable,readonly,copy) NSURL *sui_toURL;
@property (nullable,readonly,copy) NSURLRequest *sui_toURLRequest;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Manipulation
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Manipulation

#pragma mark Formatter

+ (nullable NSString *)sui_stringFromObject:(id)cObject;

#pragma mark Appending

- (NSString *)sui_appendingObject:(id)cObject;
- (NSString *)sui_appendingString:(NSString *)cString;
- (NSString *)sui_appendingFormat:(NSString *)cFormat, ... NS_FORMAT_FUNCTION(1,2);

#pragma mark Contains

- (BOOL)sui_containsObject:(id)cObject;
- (BOOL)sui_containsString:(NSString *)cString;
- (BOOL)sui_isNotEmpty;

#pragma mark Regex

- (nullable NSString *)sui_regex:(NSString *)cRegex;

#pragma mark Delstr

- (NSString *)sui_delstrBlankInHeadTail;
- (NSString *)sui_delstrBlankAndWrapInHeadTail;
- (NSString *)sui_delstrStringInHeadTail:(NSString *)cString;
- (NSString *)sui_delstrWrapInHeadTail;

#pragma mark Substr

- (NSString *)sui_substrToIndex:(NSUInteger)cIndex;
- (nullable NSString *)sui_substrFromIndex:(NSUInteger)cIndex;
- (nullable NSString *)sui_substrWithRange:(NSRange)cRange;

#pragma mark Replace

- (NSString *)sui_replaceString:(NSString *)cString withString:(NSString *)cReplacement;
- (NSString *)sui_replaceString:(NSString *)cString withString:(NSString *)cReplacement options:(NSStringCompareOptions)cOptions;
- (NSString *)sui_replaceRegex:(NSString *)cRegex withString:(NSString *)cReplacement;

#pragma mark Resource

- (nullable NSString *)sui_resourceNameCompleteOfType:(nullable NSString *)ext;
- (nullable NSString *)sui_resourcePathForMainBundleOfType:(nullable NSString *)ext;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Encoded
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Encoded

#pragma mark URL

- (nullable NSString *)sui_URLEncoded;
- (nullable NSString *)sui_URLDecoded;

#pragma mark Base64

- (nullable NSString *)sui_base64Encoded;
- (nullable NSString *)sui_base64Decoded;

#pragma mark SHA1 MD5 SHA224 SHA256 SHA384 SHA512

- (nullable NSString *)sui_md5Digest;
- (nullable NSString *)sui_HMACDigestWithKey:(NSString *)cKey algorithm:(CCHmacAlgorithm)cAlgorithm;

#pragma mark Rc4

- (nullable NSData *)sui_rc4WithKey:(NSString *)cKey;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Validate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Validate

- (BOOL)sui_validateNickname;


@end

NS_ASSUME_NONNULL_END
