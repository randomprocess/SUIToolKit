//
//  UIImage+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/23.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIImage+SUIExt.h"
#import "SUIToolKitConst.h"

@implementation UIImage (SUIExt)


- (UIImage *)toFitWidth:(CGFloat)maxWidth
{
    CGFloat btWidth = 0;
    CGFloat btHeight = 0;
    
    if (self.size.width > self.size.height) {
        btHeight = maxWidth;
        btWidth = self.size.width * (maxWidth / self.size.height);
    } else {
        btWidth = maxWidth;
        btHeight = self.size.height * (maxWidth / self.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self toSize:targetSize];
}

- (UIImage *)toFitHeight:(CGFloat)maxHeight
{
    CGFloat btWidth = 0;
    CGFloat btHeight = 0;
    
    if (self.size.height > self.size.width) {
        btWidth = maxHeight;
        btHeight = self.size.height * (maxHeight / self.size.width);
    } else {
        btHeight = maxHeight;
        btWidth = self.size.width * (maxHeight / self.size.height);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self toSize:targetSize];
}

- (UIImage *)toSize:(CGSize)targetSize
{
    CGSize curSize = self.size;
    if (CGSizeEqualToSize(curSize, targetSize)) {
        return self;
    }
    
    CGFloat scaleFactor = 0;
    CGFloat scaledWidth = targetSize.width;
    CGFloat scaledHeight = targetSize.height;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    CGFloat widthFactor = scaledWidth / curSize.width;
    CGFloat heightFactor = scaledHeight / curSize.width;
    
    if (widthFactor > heightFactor) {
        scaleFactor = widthFactor; // scale to fit height
    } else {
        scaleFactor = heightFactor; // scale to fit width
    }
    
    scaledWidth  = curSize.width * scaleFactor;
    scaledHeight = curSize.height * scaleFactor;
    
    // center the image
    if (widthFactor > heightFactor) {
        thumbnailPoint.y = (targetSize.height - scaledHeight) * 0.5;
    } else if (widthFactor < heightFactor) {
        thumbnailPoint.x = (targetSize.width - scaledWidth) * 0.5;
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight);
    [self drawInRect:thumbnailRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) uLogError(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



- (UIImage *)imageWithTintColo:(UIColor *)tintColor
{
    return [self imageWithTintColo:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColo:(UIColor *)tintColor
{
    return [self imageWithTintColo:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColo:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
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
