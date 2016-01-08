//
//  UIView+SUIAdditions.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/11/25.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UIView+SUIAdditions.h"
#import "SUIUtilities.h"
#import "ReactiveCocoa.h"
#import "NSObject+SUIAdditions.h"

@implementation UIView (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Nib
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Nib

- (BOOL)sui_loadNib
{
    UIView *curMainView = [self sui_mainView];
    if (!curMainView) {
        [self setSui_loadNib:YES];
    }
    return YES;
}
- (void)setSui_loadNib:(BOOL)sui_loadNib
{
    if (sui_loadNib) {
        UIView *curMainView = [self sui_mainView];
        if (!curMainView) {
            curMainView = [[NSBundle mainBundle] loadNibNamed:gClassName(self) owner:self options:nil][0];
            [self setSui_mainView:curMainView];
            [self addSubview:curMainView];
            
            self.backgroundColor = [UIColor clearColor];
            curMainView.frame = self.bounds;
            [curMainView sui_layoutPinnedToSuperview];
        }
    } else {
        [self setSui_mainView:nil];
    }
}

- (UIView *)sui_mainView
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_mainView)];
}
- (void)setSui_mainView:(UIView *)sui_mainView
{
    [self sui_setAssociatedObject:sui_mainView key:@selector(sui_mainView) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Layer
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Layer

#pragma mark corner

- (CGFloat)sui_cornerRadius
{
    return self.layer.cornerRadius;
}
- (void)setSui_cornerRadius:(CGFloat)sui_cornerRadius
{
    self.layer.cornerRadius = sui_cornerRadius;
    self.layer.masksToBounds = (sui_cornerRadius > 0);
}

#pragma mark border

- (CGFloat )sui_borderWidth
{
    return self.layer.borderWidth;
}
- (void)setSui_borderWidth:(CGFloat)sui_borderWidth
{
    self.layer.borderWidth = sui_borderWidth;
}

- (UIColor *)sui_borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (void)setSui_borderColor:(UIColor *)sui_borderColor
{
    self.layer.borderColor = [sui_borderColor CGColor];
}

#pragma mark shadow

- (UIColor *)sui_shadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}
- (void)setSui_shadowColor:(UIColor *)sui_shadowColor
{
    self.layer.shadowColor = [sui_shadowColor CGColor];
}

- (CGFloat)sui_shadowOpacity
{
    return self.layer.shadowOpacity;
}
- (void)setSui_shadowOpacity:(CGFloat)sui_shadowOpacity
{
    self.layer.shadowOpacity = sui_shadowOpacity;
}

- (CGSize)sui_shadowOffset
{
    return self.layer.shadowOffset;
}
- (void)setSui_shadowOffset:(CGSize)sui_shadowOffset
{
    self.layer.shadowOffset = sui_shadowOffset;
}

- (CGFloat)sui_shadowRadius
{
    return self.layer.shadowRadius;
}
- (void)setSui_shadowRadius:(CGFloat)sui_shadowRadius
{
    self.layer.shadowRadius = sui_shadowRadius;
}

- (BOOL)sui_shadowPath
{
    if (self.layer.shadowRadius) return YES;
    return NO;
}
- (void)setSui_shadowPath:(BOOL)sui_shadowPath
{
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.layer.bounds] CGPath];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Frame
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Frame

- (CGFloat)sui_x
{
    return self.frame.origin.x;
}
- (void)setSui_x:(CGFloat)sui_x
{
    CGRect curRect = self.frame;
    if (curRect.origin.x != sui_x) {
        curRect.origin.x = sui_x;
        self.frame = curRect;
    }
}

- (CGFloat)sui_y
{
    return self.frame.origin.y;
}
- (void)setSui_y:(CGFloat)sui_y
{
    CGRect curRect = self.frame;
    if (curRect.origin.y != sui_y) {
        curRect.origin.y = sui_y;
        self.frame = curRect;
    }
}

- (CGFloat)sui_width
{
    return self.frame.size.width;
}
- (void)setSui_width:(CGFloat)sui_width
{
    CGRect curRect = self.frame;
    if (curRect.size.width != sui_width) {
        curRect.size.width = sui_width;
        self.frame = curRect;
    }
}

- (CGFloat)sui_height
{
    return self.frame.size.height;
}
- (void)setSui_height:(CGFloat)sui_height
{
    CGRect curRect = self.frame;
    if (curRect.size.height != sui_height) {
        curRect.size.height = sui_height;
        self.frame = curRect;
    }
}

- (CGFloat)sui_maxX
{
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)sui_maxY
{
    return CGRectGetMaxY(self.frame);
}
- (CGFloat)sui_midX
{
    return CGRectGetMidX(self.frame);
}
- (CGFloat)sui_midY
{
    return CGRectGetMidY(self.frame);
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Relationship
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Relationship

- (UIViewController *)sui_currentVC
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

- (UIView *)sui_firstSubviewOfClass:(Class)aClass
{
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:aClass])
        {
            return subView;
        }
    }
    return nil;
}

- (UIView *)sui_firstSupviewOfClass:(Class)aClass;
{
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

#pragma mark - Constraint

- (NSLayoutConstraint *)sui_layoutConstraintWithAttribute:(NSLayoutAttribute)attr
{
    switch (attr) {
        case NSLayoutAttributeTop:
        case NSLayoutAttributeBottom:
        case NSLayoutAttributeLeading:
        case NSLayoutAttributeTrailing:
        {
            UIView *next = [self superview];
            if (next)
            {
                for (NSLayoutConstraint *subConstraint in next.constraints)
                {
                    if (subConstraint.secondItem == self && subConstraint.firstAttribute == attr)
                    {
                        return subConstraint;
                    }
                }
            }
        }
            break;
        case NSLayoutAttributeWidth:
        case NSLayoutAttributeHeight:
        {
            for (NSLayoutConstraint *subConstraint in self.constraints)
            {
                if (subConstraint.firstAttribute == attr)
                {
                    return subConstraint;
                }
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

- (NSLayoutConstraint *)sui_layoutConstraintTop
{
    return [self sui_layoutConstraintWithAttribute:NSLayoutAttributeTop];
}
- (NSLayoutConstraint *)sui_layoutConstraintBottom
{
    return [self sui_layoutConstraintWithAttribute:NSLayoutAttributeBottom];
}
- (NSLayoutConstraint *)sui_layoutConstraintLeading
{
    return [self sui_layoutConstraintWithAttribute:NSLayoutAttributeLeading];
}
- (NSLayoutConstraint *)sui_layoutConstraintTrailing
{
    return [self sui_layoutConstraintWithAttribute:NSLayoutAttributeTrailing];
}

- (NSLayoutConstraint *)sui_layoutConstraintWidth
{
    return [self sui_layoutConstraintWithAttribute:NSLayoutAttributeWidth];
}
- (NSLayoutConstraint *)sui_layoutConstraintHeight
{
    return [self sui_layoutConstraintWithAttribute:NSLayoutAttributeHeight];
}

- (void)sui_layoutPinnedToSuperview
{
    uAssert(self.superview, @"no superview");
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.superview addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[self]-0-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(self)]];
    [self.superview addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[self]-0-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(self)]];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Snapshotting
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Snapshotting

- (UIView *)sui_snapshotView:(BOOL)arterUpdates
{
    return [self snapshotViewAfterScreenUpdates:arterUpdates];
}

- (UIImage *)sui_snapshotImage:(BOOL)arterUpdates
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:arterUpdates];
    UIImage *curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return curImage;
}

- (UIImage *)sui_snapshotWithRenderInContext
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return curImage;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  GestureRecognizer
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - GestureRecognizer

- (void)sui_handleTapGes:(UITapGestureRecognizer *)tapGes {}

- (void)sui_addTapGes:(void (^)(UITapGestureRecognizer *cTapGes))completion
{
    if (!self.userInteractionEnabled) self.userInteractionEnabled = !self.userInteractionEnabled;
    
    SEL curSel = @selector(sui_handleTapGes:);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:curSel];
    [self addGestureRecognizer:tapGes];
    [[self rac_signalForSelector:curSel] subscribeNext:^(RACTuple *cTuple) {
        completion(cTuple.first);
    }];
}

- (void)sui_handleLongPressGes:(UILongPressGestureRecognizer *)longPressGes {}

- (void)sui_addLongPressGes:(void (^)(UILongPressGestureRecognizer *cLongPressGes))completion
{
    if (!self.userInteractionEnabled) self.userInteractionEnabled = !self.userInteractionEnabled;
    
    SEL curSel = @selector(sui_handleLongPressGes:);
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:curSel];
    [self addGestureRecognizer:longPressGes];
    [[self rac_signalForSelector:curSel] subscribeNext:^(RACTuple *cTuple) {
        completion(cTuple.first);
    }];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Animation
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Animation

- (void)sui_show
{
    [self sui_showWithDuration:0.25 animationType:SUIViewAnimationTypeFade];
}
- (void)sui_showWithDuration:(NSTimeInterval)duration animationType:(SUIViewAnimationType)cType
{
    switch (cType) {
        case SUIViewAnimationTypeFade:
        {
            if (self.alpha != 0) self.alpha = 0;
            [UIView animateWithDuration:duration
                             animations:^{
                                 self.alpha = 1.0;
                             } completion:^(BOOL finished) {
                             }];
        }
            break;
            
        default:
            break;
    }
}

- (void)sui_hide
{
    [self sui_hideWithDuration:0.25 animateType:SUIViewAnimationTypeFade remove:NO];
}
- (void)sui_hideAndRemoveFromSupview
{
    [self sui_hideWithDuration:0.25 animateType:SUIViewAnimationTypeFade remove:YES];
}
- (void)sui_hideWithDuration:(NSTimeInterval)duration animateType:(SUIViewAnimationType)cType remove:(BOOL)remove
{
    switch (cType) {
        case SUIViewAnimationTypeFade:
        {
            [UIView animateWithDuration:duration
                             animations:^{
                                 self.alpha = 0;
                             } completion:^(BOOL finished) {
                                 if (remove && self.superview) {
                                     [self removeFromSuperview];
                                 }
                             }];
        }
            break;
            
        default:
            break;
    }
}

@end
