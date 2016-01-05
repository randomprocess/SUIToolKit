//
//  NSObject+SUIAdditions.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/8.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "ReactiveCocoa.h"

@class SUIKeyboardInfo;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  AssociatedObject
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - AssociatedObject

- (void)sui_setAssociatedObject:(nullable id)cValue key:(const void *)cKey policy:(objc_AssociationPolicy)cPolicy;

- (nullable id)sui_getAssociatedObjectWithKey:(const void *)cKey;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Keyboard
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Keyboard

@property (readonly,copy) RACSignal *sui_keyboardWillChangeSignal; // SUIKeyboardInfo


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  PerformedOnce
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - PerformedOnce

- (void)sui_performOnce:(void (^)(void))cb key:(NSString *)cKey;


@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIKeyboardInfo
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUIKeyboardInfo : NSObject

@property (nonatomic) BOOL show;
@property (nonatomic) UIViewAnimationOptions options;
@property (nonatomic) double duration;
@property (nonatomic) CGRect frameBegin;
@property (nonatomic) CGRect frameEnd;
@property (nonatomic) BOOL isLocal;

@property (nonatomic,readonly) CGFloat keyboardHeight;

@end


NS_ASSUME_NONNULL_END
