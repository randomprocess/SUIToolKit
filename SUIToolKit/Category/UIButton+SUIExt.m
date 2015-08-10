//
//  UIButton+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/23.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIButton+SUIExt.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

const CGFloat WZFlashInnerCircleInitialRaius = 20;


@implementation UIButton (SUIExt)


+ (instancetype)customBtn
{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}


// _____________________________________________________________________________

- (void)setNormalTitle:(NSString *)normalTitle
{
    [self setTitle:normalTitle forState:UIControlStateNormal];
}
- (NSString *)normalTitle
{
    return [self titleForState:UIControlStateNormal];
}

- (void)setNormalTitleColo:(UIColor *)normalTitleColo
{
    [self setTitleColor:normalTitleColo forState:UIControlStateNormal];
}
- (UIColor *)normalTitleColo
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


// _____________________________________________________________________________

- (void)setPressedTitle:(NSString *)pressedTitle
{
    [self setTitle:pressedTitle forState:UIControlStateHighlighted];
}
- (NSString *)pressedTitle
{
    return [self titleForState:UIControlStateHighlighted];
}

- (void)setPressedTitleColo:(UIColor *)pressedTitleColo
{
    [self setTitleColor:pressedTitleColo forState:UIControlStateHighlighted];
}
- (UIColor *)pressedTitleColo
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


// _____________________________________________________________________________

- (void)setSelectedTitle:(NSString *)selectedTitle
{
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}
- (NSString *)selectedTitle
{
    return [self titleForState:UIControlStateSelected];
}

- (void)setSelectedTitleColo:(UIColor *)selectedTitleColo
{
    [self setTitleColor:selectedTitleColo forState:UIControlStateSelected];
}
- (UIColor *)selectedTitleColo
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


// _____________________________________________________________________________

- (void)setDisabledTitle:(NSString *)disabledTitle
{
    [self setTitle:disabledTitle forState:UIControlStateDisabled];
}
- (NSString *)disabledTitle
{
    return [self titleForState:UIControlStateDisabled];
}

- (void)setDisabledTitleColo:(UIColor *)disabledTitleColo
{
    [self setTitleColor:disabledTitleColo forState:UIControlStateDisabled];
}
- (UIColor *)disabledTitleColo
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


// _____________________________________________________________________________

- (void)setPadding:(CGFloat)padding
{
    self.contentEdgeInsets = UIEdgeInsetsMake(0, padding, 0, padding);
    [self sizeToFit];
}
- (CGFloat)padding
{
    UIEdgeInsets curInsets = self.contentEdgeInsets;
    if (curInsets.left == curInsets.right)
    {
        return curInsets.left;
    }
    return 0;
}

- (void)setInsets:(UIEdgeInsets)insets
{
    self.contentEdgeInsets = insets;
    [self sizeToFit];
}
- (UIEdgeInsets)insets
{
    return self.contentEdgeInsets;
}


// _____________________________________________________________________________

- (SUIButtonFlashType)flashType
{
    return [objc_getAssociatedObject(self, @selector(flashType)) integerValue];
}
- (void)setFlashType:(SUIButtonFlashType)flashType
{
    if (flashType == self.flashType)
    {
        return;
    }
    
    if (self.flashType == SUIButtonFlashTypeNormal)
    {
        UITapGestureRecognizer *curTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doFlashTap:)];
        curTapGes.cancelsTouchesInView = NO;
        [self addGestureRecognizer:curTapGes];
        curTapGes.view.tag = 1649052;
    }
    else
    {
        for (UIGestureRecognizer *curGes in [self gestureRecognizers]) {
            if ([curGes isKindOfClass:[UITapGestureRecognizer class]])
            {
                if (curGes.view.tag == 1649052)
                {
                    [self removeGestureRecognizer:curGes];
                    break;
                }
            }
        }
        
        self.clipsToBounds = (self.flashType == SUIButtonFlashTypeInner);
    }
    
    objc_setAssociatedObject(self, @selector(flashType), @(flashType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)flashColo
{
    return objc_getAssociatedObject(self, @selector(flashColo));
}
- (void)setFlashColo:(UIColor *)flashColo
{
    objc_setAssociatedObject(self, @selector(flashColo), flashColo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)doFlashTap:(UITapGestureRecognizer *)tapGes
{
    CGPoint tapLocation = [tapGes locationInView:self];
    CAShapeLayer *circleShape = nil;
    CGFloat scale = 1.0f;
    
    CGFloat width = self.bounds.size.width, height = self.bounds.size.height;
    
    if (self.flashType == SUIButtonFlashTypeInner) {
        CGFloat biggerEdge = width > height ? width : height;
        CGFloat smallerEdge = width > height ? height : width;
        CGFloat radius = smallerEdge / 2 > WZFlashInnerCircleInitialRaius ? WZFlashInnerCircleInitialRaius : smallerEdge / 2;
        
        scale = biggerEdge / radius + 0.5;
        circleShape = [self createCircleShapeWithPosition:CGPointMake(tapLocation.x - radius, tapLocation.y - radius)
                                                 pathRect:CGRectMake(0, 0, radius * 2, radius * 2)
                                                   radius:radius];
    } else {
        scale = 2.5f;
        circleShape = [self createCircleShapeWithPosition:CGPointMake(width/2, height/2)
                                                 pathRect:CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), width, height)
                                                   radius:self.layer.cornerRadius];
    }
    
    [self.layer addSublayer:circleShape];
    
    CAAnimationGroup *groupAnimation = [self createFlashAnimationWithScale:scale duration:0.5f];
    
    /* Use KVC to remove layer to avoid memory leak */
    [groupAnimation setValue:circleShape forKey:@"circleShaperLayer"];
    
    [circleShape addAnimation:groupAnimation forKey:nil];
//    [circleShape setDelegate:self];
}

- (CAShapeLayer *)createCircleShapeWithPosition:(CGPoint)position pathRect:(CGRect)rect radius:(CGFloat)radius
{
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = [self createCirclePathWithRadius:rect radius:radius];
    circleShape.position = position;
    
    if (self.flashType == SUIButtonFlashTypeInner) {
        circleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
        circleShape.fillColor = self.flashColo ? self.flashColo.CGColor : [UIColor whiteColor].CGColor;
    } else {
        circleShape.fillColor = [UIColor clearColor].CGColor;
        circleShape.strokeColor = self.flashColo ? self.flashColo.CGColor : [UIColor purpleColor].CGColor;
    }
    
    circleShape.opacity = 0;
    circleShape.lineWidth = 1;
    
    return circleShape;
}

- (CAAnimationGroup *)createFlashAnimationWithScale:(CGFloat)scale duration:(CGFloat)duration
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return animation;
}

- (CGPathRef)createCirclePathWithRadius:(CGRect)frame radius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}



- (SUIButtonClickBlock)clickBlock
{
    return objc_getAssociatedObject(self, @selector(clickBlock));
}
- (void)setClickBlock:(SUIButtonClickBlock)clickBlock
{
    [self addTarget:self action:@selector(clickBtnAction) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, @selector(clickBlock), clickBlock, OBJC_ASSOCIATION_COPY);
}

- (void)clickBtnAction
{
    if (self.clickBlock)
    {
        self.clickBlock();
    }
}


@end
