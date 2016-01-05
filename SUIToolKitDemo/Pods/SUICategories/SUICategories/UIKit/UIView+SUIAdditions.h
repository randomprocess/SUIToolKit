//
//  UIView+SUIAdditions.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/11/25.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SUIViewAnimationTypeFade
} SUIViewAnimationType;


@interface UIView (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Nib
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Nib

@property (nonatomic) IBInspectable BOOL sui_loadNib;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Layer
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Layer

#pragma mark corner

@property (nonatomic) IBInspectable CGFloat sui_cornerRadius; // Defaults to zero.

#pragma mark border

@property (nonatomic) IBInspectable CGFloat sui_borderWidth; // Defaults to zero. [0,1]
@property (nullable,nonatomic,copy) IBInspectable UIColor *sui_borderColor; // Defaults to opaque black.

#pragma mark shadow

@property (nullable,nonatomic,copy) IBInspectable UIColor *sui_shadowColor; // Defaults to opaque black
@property (nonatomic) IBInspectable CGFloat sui_shadowOpacity; // Defaults to 0. [0,1]
@property (nonatomic) IBInspectable CGSize sui_shadowOffset; // Defaults to (0, -3).
@property (nonatomic) IBInspectable CGFloat sui_shadowRadius; // Defaults to 3.
@property (nonatomic) BOOL sui_shadowPath; // Defaults to NO. When using animation to YES.


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Frame
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Frame

@property (nonatomic) CGFloat sui_x;
@property (nonatomic) CGFloat sui_y;
@property (nonatomic) CGFloat sui_width;
@property (nonatomic) CGFloat sui_height;

@property (readonly) CGFloat sui_maxX; // (x + width).
@property (readonly) CGFloat sui_maxY; // (y + height).
@property (readonly) CGFloat sui_midX; // (x + width/2).
@property (readonly) CGFloat sui_midY; // (y + height/2).


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Relationship
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Relationship

@property (nullable,readonly,copy) __kindof UIViewController *sui_currentVC;

- (nullable __kindof UIView *)sui_firstSubviewOfClass:(Class)aClass;
- (nullable __kindof UIView *)sui_firstSupviewOfClass:(Class)aClass;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Constraint
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Constraint

- (nullable NSLayoutConstraint *)sui_layoutConstraintTop;
- (nullable NSLayoutConstraint *)sui_layoutConstraintBottom;
- (nullable NSLayoutConstraint *)sui_layoutConstraintLeading;
- (nullable NSLayoutConstraint *)sui_layoutConstraintTrailing;

- (nullable NSLayoutConstraint *)sui_layoutConstraintWidth;
- (nullable NSLayoutConstraint *)sui_layoutConstraintHeight;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Snapshotting
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Snapshotting

- (nullable UIView *)sui_snapshotView:(BOOL)arterUpdates;
- (null_unspecified UIImage *)sui_snapshotImage:(BOOL)arterUpdates;
- (null_unspecified UIImage *)sui_snapshotWithRenderInContext;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  GestureRecognizer
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - GestureRecognizer

- (void)sui_addTapGes:(void (^)(UITapGestureRecognizer *cTapGes))completion;
- (void)sui_addLongPressGes:(void (^)(UILongPressGestureRecognizer *cLongPressGes))completion;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Animation
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Animation

- (void)sui_show; // Default duration is 0.2s, animateType is Fade.
- (void)sui_showWithDuration:(NSTimeInterval)duration animationType:(SUIViewAnimationType)cType;

- (void)sui_hide; // Default duration is 0.2s, animateType is Fade, not be removed from supview
- (void)sui_hideAndRemoveFromSupview;
- (void)sui_hideWithDuration:(NSTimeInterval)duration animateType:(SUIViewAnimationType)cType remove:(BOOL)remove;


@end

NS_ASSUME_NONNULL_END
