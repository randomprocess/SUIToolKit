//
//  NSData+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/21.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SUIExt)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Base64
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64EncodedData;
- (NSData *)base64DecodedData;


@end
