//
//  UIImage+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/22.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "UIImage+SUIAdditions.h"

@implementation UIImage (SUIAdditions)


- (UIImage *)sui_imageWithTintColor:(UIColor *)tintColo
{
    return [self sui_imageWithTintColor:tintColo blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)sui_imageWithGradientTintColor:(UIColor *)tintColo
{
    return [self sui_imageWithTintColor:tintColo blendMode:kCGBlendModeOverlay];
}

- (UIImage *)sui_imageWithTintColor:(UIColor *)tintColo blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColo setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


@end
