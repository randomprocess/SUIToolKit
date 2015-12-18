//
//  UITabBarItem+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/14.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "UITabBarItem+SUIAdditions.h"

@implementation UITabBarItem (SUIAdditions)


- (UIImage *)sui_originalSelectedImage
{
    return self.selectedImage;
}
- (void)setSui_originalSelectedImage:(UIImage *)sui_originalSelectedImage
{
    self.selectedImage = [sui_originalSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIColor *)sui_normalTitleColo
{
    return [[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal][NSForegroundColorAttributeName];
}
- (void)setSui_normalTitleColo:(UIColor *)sui_normalTitleColo
{    
    [[UITabBarItem appearance]
     setTitleTextAttributes:@{
                              NSForegroundColorAttributeName:sui_normalTitleColo
                              }
     forState:UIControlStateNormal];
}

- (UIColor *)sui_selectedTitleColo
{
    return [[UITabBarItem appearance] titleTextAttributesForState:UIControlStateSelected][NSForegroundColorAttributeName];
}
- (void)setSui_selectedTitleColo:(UIColor *)sui_selectedTitleColo
{
    [[UITabBarItem appearance]
     setTitleTextAttributes:@{
                              NSForegroundColorAttributeName:sui_selectedTitleColo
                              }
     forState:UIControlStateSelected];
}


@end
