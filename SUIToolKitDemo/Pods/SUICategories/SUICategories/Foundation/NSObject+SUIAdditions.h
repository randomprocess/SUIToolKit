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

- (void)sui_keyboardWillChange:(void (^)(BOOL showKeyboard, CGFloat keyboardHeight, UIViewAnimationOptions options, double duration))cb;


@end

NS_ASSUME_NONNULL_END