//
//  UIColor+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/14.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIColor+SUIExt.h"

@implementation UIColor (SUIExt)


#pragma mark - Color from Hex/RGBA/HSBA

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
