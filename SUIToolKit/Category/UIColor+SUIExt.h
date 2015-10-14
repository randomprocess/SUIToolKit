//
//  UIColor+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/14.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>


#define gHex(__string) [UIColor colorFromHexString:__string];

@interface UIColor (SUIExt)


#pragma mark - Color from Hex/RGBA/HSBA
/**
 Creates a UIColor from a Hex representation string
 @param hexString   Hex string that looks like @"#FF0000" or @"FF0000"
 @return    UIColor
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString;


@end
