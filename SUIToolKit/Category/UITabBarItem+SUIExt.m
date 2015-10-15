//
//  UITabBarItem+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/15.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UITabBarItem+SUIExt.h"

@implementation UITabBarItem (SUIExt)


- (void)setOriginalSelectedImage:(UIImage *)originalSelectedImage
{
    self.selectedImage = [originalSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)originalSelectedImage
{
    return self.selectedImage;
}

- (void)setNormalTitleColo:(UIColor *)normalTitleColo
{
    [[UITabBarItem appearance]
     setTitleTextAttributes:@{
                              NSForegroundColorAttributeName:normalTitleColo
                              }
     forState:UIControlStateNormal];
}
- (UIColor *)normalTitleColo
{
    return [[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal][NSForegroundColorAttributeName];
}

- (void)setSelectedTitleColo:(UIColor *)selectedTitleColo
{
    [[UITabBarItem appearance]
     setTitleTextAttributes:@{
                              NSForegroundColorAttributeName:selectedTitleColo
                              }
     forState:UIControlStateSelected];
}
- (UIColor *)selectedTitleColo
{
    return [[UITabBarItem appearance] titleTextAttributesForState:UIControlStateSelected][NSForegroundColorAttributeName];
}

@end
