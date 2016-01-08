//
//  UIImage+SUIGIF.h
//  SUIToolKitDemo
//
//  Created by zzZ on 16/1/6.
//  Copyright © 2016年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SUIGIF)


+ (UIImage * __null_unspecified)sui_animatedGIFNamed:(NSString *)name;

+ (UIImage * __null_unspecified)sui_animatedGIFWithData:(NSData *)data;

- (UIImage * __null_unspecified)sui_animatedImageByScalingAndCroppingToSize:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
