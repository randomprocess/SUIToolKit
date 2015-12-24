//
//  UIImage+SUIBlurEffect.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/22.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SUIBlurEffect)


- (UIImage * __null_unspecified)sui_imageByApplyingLightEffect;
- (UIImage * __null_unspecified)sui_imageByApplyingExtraLightEffect;
- (UIImage * __null_unspecified)sui_imageByApplyingDarkEffect;
- (UIImage * __null_unspecified)sui_imageByApplyingTintEffectWithColor:(nullable UIColor *)tintColo;

- (UIImage * __null_unspecified)sui_imageByApplyingBlurWithRadius:(CGFloat)blurRadius tintColor:(nullable UIColor *)tintColo saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(nullable UIImage *)maskImage;


@end

NS_ASSUME_NONNULL_END
