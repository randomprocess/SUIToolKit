//
//  UIView+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIView+SUIExt.h"

@implementation UIView (SUIExt)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Layer
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (void)setBorder:(UIColor * _Nonnull)color width:(CGFloat)width
{
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
}

- (void)setShadow:(UIColor * _Nonnull)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius
{
    CALayer *l = self.layer;
    l.shadowColor = [color CGColor];
    l.shadowOpacity = opacity;
    l.shadowOffset = offset;
    l.shadowRadius = blurRadius;
    l.shadowPath = [[UIBezierPath bezierPathWithRect:l.bounds] CGPath];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Frame
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

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


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Controller
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (__kindof UIViewController * _Nullable)theVC
{
    Class aClass = NSClassFromString(@"UIViewController");
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:aClass])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (__kindof UIView * _Nullable)subviewWithClassName:(NSString * _Nonnull)className
{
    Class aClass = NSClassFromString(className);
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:aClass])
        {
            return subView;
        }
    }
    return nil;
}

- (__kindof UIView * _Nullable)supviewWithClassName:(NSString * _Nonnull)className
{
    Class aClass = NSClassFromString(className);
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIView *curView = [next superview];
        if ([curView isKindOfClass:aClass])
        {
            return curView;
        }
    }
    return nil;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Constraint
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (NSLayoutConstraint * _Nullable)contantTop
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
- (NSLayoutConstraint * _Nullable)contantBottom
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

- (NSLayoutConstraint * _Nullable)contantWidth
{
    for (NSLayoutConstraint *subConstraint in self.constraints)
    {
        if (subConstraint.firstAttribute == NSLayoutAttributeWidth)
        {
            return subConstraint;
        }
    }
    return nil;
}
- (NSLayoutConstraint * _Nullable)contantHeight
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


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Snapshot
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (UIImage * _Null_unspecified)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return curImage;
}

- (UIImage * _Null_unspecified)snapshotWithRender
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return curImage;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Ges
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (void)addTapGesWithTarget:(id _Nonnull)cTarget sel:(SEL _Nonnull)cSel
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:cTarget action:cSel];
    [tapGes setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGes];
}

- (void)addLongPressGesWithTarget:(id _Nonnull)cTarget sel:(SEL _Nonnull)cSel
{
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:cTarget action:cSel];
    [self addGestureRecognizer:longPressGes];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Animate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (void)showWithAnimateType:(SUIViewAnimateType)cType duration:(NSTimeInterval)cDuration
{
    if (cType == SUIViewAnimateTypeFade)
    {
        if (self.alpha != 0) self.alpha = 0;
        [UIView animateWithDuration:cDuration
                         animations:^{
                             self.alpha = 1.0;
                         } completion:^(BOOL finished) {
                         }];
    }
}
- (void)hideWithAnimateType:(SUIViewAnimateType)cType duration:(NSTimeInterval)cDuration remove:(BOOL)remove
{
    if (cType == SUIViewAnimateTypeFade)
    {
        [UIView animateWithDuration:cDuration
                         animations:^{
                             self.alpha = 0;
                         } completion:^(BOOL finished) {
                             if (remove) {
                                 [self removeFromSuperview];
                             }
                         }];
    }
}


@end
