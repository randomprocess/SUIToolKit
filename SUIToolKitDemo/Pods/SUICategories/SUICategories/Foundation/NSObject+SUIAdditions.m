//
//  NSObject+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/8.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "NSObject+SUIAdditions.h"
#import "ReactiveCocoa.h"

@implementation NSObject (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  AssociatedObject
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - AssociatedObject

- (void)sui_setAssociatedObject:(nullable id)cValue key:(const void *)cKey policy:(objc_AssociationPolicy)cPolicy
{
    objc_setAssociatedObject(self, cKey, cValue, cPolicy);
}

- (nullable id)sui_getAssociatedObjectWithKey:(const void *)cKey
{
    return objc_getAssociatedObject(self, cKey);
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Keyboard
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Keyboard

- (void)sui_keyboardWillChange:(void (^)(BOOL showKeyboard, CGFloat keyboardHeight, UIViewAnimationOptions options, double duration))cb
{
    // registerForKeyboardNotifications
    @weakify(self);
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
     subscribeNext:^(id x) {
         @strongify(self);
         [self sui_keyboardWillShowOrHide:YES noti:x keyboardChangeBlock:cb];
     }];
    
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
     subscribeNext:^(id x) {
         @strongify(self);
         [self sui_keyboardWillShowOrHide:NO noti:x keyboardChangeBlock:cb];
     }];
}

- (void)sui_keyboardWillShowOrHide:(BOOL)showKeyboard noti:(NSNotification *)cNoti keyboardChangeBlock:(void (^)(BOOL showKeyboard, CGFloat keyboardHeight, UIViewAnimationOptions options, double duration))cb
{
    CGRect keyboardRect = [[cNoti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    double duration = [[cNoti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [[cNoti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if (cb) {
        if (showKeyboard) {
            cb(showKeyboard, keyboardHeight, options, duration);
        } else {
            cb(showKeyboard, 0, options, duration);
        }
    }
}


@end
