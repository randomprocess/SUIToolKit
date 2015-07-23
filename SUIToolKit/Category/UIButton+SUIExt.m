//
//  UIButton+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/23.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIButton+SUIExt.h"

@implementation UIButton (SUIExt)


+ (UIButton *)customBtn
{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}


- (void)setNormalTitle:(NSString *)normalTitle
{
    [self setTitle:normalTitle forState:UIControlStateNormal];
}
- (NSString *)normalTitle
{
    return [self titleForState:UIControlStateNormal];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
}
- (UIColor *)normalTitleColor
{
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setNormalImage:(UIImage *)normalImage
{
    [self setImage:normalImage forState:UIControlStateNormal];
}
- (UIImage *)normalImage
{
    return [self imageForState:UIControlStateNormal];
}

- (void)setNormalBackgroundImage:(UIImage *)normalBackgroundImage
{
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
}
- (UIImage *)normalBackgroundImage
{
    return [self backgroundImageForState:UIControlStateNormal];
}


- (void)setPressedTitle:(NSString *)pressedTitle
{
    [self setTitle:pressedTitle forState:UIControlStateHighlighted];
}
- (NSString *)pressedTitle
{
    return [self titleForState:UIControlStateHighlighted];
}

- (void)setPressedTitleColor:(UIColor *)pressedTitleColor
{
    [self setTitleColor:pressedTitleColor forState:UIControlStateHighlighted];
}
- (UIColor *)pressedTitleColor
{
    return [self titleColorForState:UIControlStateHighlighted];
}

- (void)setPressedImage:(UIImage *)pressedImage
{
    [self setImage:pressedImage forState:UIControlStateHighlighted];
}
- (UIImage *)pressedImage
{
    return [self imageForState:UIControlStateHighlighted];
}


- (void)setSelectedTitle:(NSString *)selectedTitle
{
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}
- (NSString *)selectedTitle
{
    return [self titleForState:UIControlStateSelected];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    [self setSelectedTitleColor:selectedTitleColor];
}
- (UIColor *)selectedTitleColor
{
    return [self titleColorForState:UIControlStateSelected];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    [self setImage:selectedImage forState:UIControlStateSelected];
}
- (UIImage *)selectedImage
{
    return [self imageForState:UIControlStateSelected];
}


- (void)setDisabledTitle:(NSString *)disabledTitle
{
    [self setTitle:disabledTitle forState:UIControlStateDisabled];
}
- (NSString *)disabledTitle
{
    return [self titleForState:UIControlStateDisabled];
}

- (void)setDisabledTitleColor:(UIColor *)disabledTitleColor
{
    [self setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
}
- (UIColor *)disabledTitleColor
{
    return [self titleColorForState:UIControlStateDisabled];
}

- (void)setDisabledImage:(UIImage *)disabledImage
{
    [self setImage:disabledImage forState:UIControlStateDisabled];
}
- (UIImage *)disabledImage
{
    return [self imageForState:UIControlStateDisabled];
}



- (void)addClickTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


@end
