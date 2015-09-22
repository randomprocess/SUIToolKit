//
//  UIView+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIView+SUIExt.h"

@implementation UIView (SUIExt)



#pragma mark - IB

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}



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



#pragma mark -

- (UIViewController *)currVC
{
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[NSClassFromString(@"UIViewController") class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



- (NSLayoutConstraint *)contantTop
{
    UIView *next = [self superview];
    if (next)
    {
        for (NSLayoutConstraint *subConstraint in next.constraints)
        {
            if (subConstraint.secondItem == self && subConstraint.firstAttribute == NSLayoutAttributeTop)
            {
                return subConstraint;
            }
        }
    }
    return nil;
}

- (NSLayoutConstraint *)contantBottom
{
    UIView *next = [self superview];
    if (next)
    {
        for (NSLayoutConstraint *subConstraint in next.constraints)
        {
            if (subConstraint.secondItem == self && subConstraint.firstAttribute == NSLayoutAttributeBottom)
            {
                return subConstraint;
            }
        }
    }
    return nil;
}

- (NSLayoutConstraint *)contantHeight
{
    for (NSLayoutConstraint *subConstraint in self.constraints)
    {
        if (subConstraint.firstAttribute == NSLayoutAttributeHeight)
        {
            return subConstraint;
        }
    }
    return nil;
}


- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return curImage;
    

}

- (id)subviewWithClassName:(NSString *)className
{
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:NSClassFromString(className)])
        {
            return subView;
        }
    }
    return nil;
}


- (void)setBorder:(UIColor *)color width:(CGFloat)width
{
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
}

- (void)setShadow:(UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius
{
    CALayer *l = self.layer;
    l.shadowColor = [color CGColor];
    l.shadowOpacity = opacity;
    l.shadowOffset = offset;
    l.shadowRadius = blurRadius;
    l.shadowPath = [[UIBezierPath bezierPathWithRect:l.bounds] CGPath];
}

@end
