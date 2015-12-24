//
//  UIImage+SUIAdditions.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/22.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SUIAdditions)


- (UIImage * __null_unspecified)sui_imageWithTintColor:(UIColor *)tintColo; // kCGBlendModeDestinationIn
- (UIImage * __null_unspecified)sui_imageWithGradientTintColor:(UIColor *)tintColo; // kCGBlendModeOverlay
- (UIImage * __null_unspecified)sui_imageWithTintColor:(UIColor *)tintColo blendMode:(CGBlendMode)blendMode;


@end

NS_ASSUME_NONNULL_END
