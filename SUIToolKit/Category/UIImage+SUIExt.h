//
//  UIImage+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/23.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SUIExt)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Fit Size
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (UIImage *)toFitWidth:(CGFloat)maxWidth;
- (UIImage *)toFitHeight:(CGFloat)maxHeight;
- (UIImage *)toSize:(CGSize)targetSize;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Blend
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (UIImage *)imageWithTintColo:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColo:(UIColor *)tintColor;
- (UIImage *)imageWithTintColo:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;


@end
