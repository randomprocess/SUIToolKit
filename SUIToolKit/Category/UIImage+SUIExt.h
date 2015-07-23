//
//  UIImage+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/23.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SUIExt)



- (UIImage *)toFitWidth:(CGFloat)maxWidth;

- (UIImage *)toSize:(CGSize)targetSize;


@end
