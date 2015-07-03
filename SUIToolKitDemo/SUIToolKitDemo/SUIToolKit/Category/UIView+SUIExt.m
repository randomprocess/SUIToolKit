//
//  UIView+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIView+SUIExt.h"

@implementation UIView (SUIExt)


#pragma mark - Frame

- (void)setX:(CGFloat)x
{
    CGRect curRect = self.frame;
    if (curRect.origin.x != x)
    {
        curRect.origin.x = x;
        self.frame = curRect;
    }
}
- (void)setY:(CGFloat)y
{
    CGRect curRect = self.frame;
    if (curRect.origin.y != y)
    {
        curRect.origin.y = y;
        self.frame = curRect;
    }
}
- (void)setWidth:(CGFloat)width
{
    CGRect curRect = self.frame;
    if (curRect.size.width != width)
    {
        curRect.size.width = width;
        self.frame = curRect;
    }
}
- (void)setHeight:(CGFloat)height
{
    CGRect curRect = self.frame;
    if (curRect.size.height != height)
    {
        curRect.size.height = height;
        self.frame = curRect;
    }
}

- (CGFloat)x
{
    return self.frame.origin.x;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
- (CGFloat)height
{
    return self.frame.size.height;
}










@end
