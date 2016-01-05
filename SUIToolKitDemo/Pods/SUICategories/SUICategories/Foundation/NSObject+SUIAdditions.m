//
//  NSObject+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/8.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "NSObject+SUIAdditions.h"
#import "SUIMacros.h"
#import "NSArray+SUIAdditions.h"

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

- (RACSignal *)sui_keyboardWillChangeSignal
{
    RACSignal *curSignal = [self sui_getAssociatedObjectWithKey:_cmd];
    if (curSignal) return curSignal;
    
    curSignal = [[[[RACSignal merge:@[
                                     [gNotiCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil],
                                     [gNotiCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
                                     ]]
                  map:^id(NSNotification * cNoti) {
                      SUIKeyboardInfo *curInfo = [SUIKeyboardInfo new];
                      if ([cNoti.name isEqualToString:UIKeyboardWillShowNotification]) {
                          curInfo.show = YES;
                      }
                      curInfo.options = [[cNoti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
                      curInfo.duration = [[cNoti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
                      curInfo.frameBegin = [[cNoti.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
                      curInfo.frameEnd = [[cNoti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                      curInfo.isLocal = [[cNoti.userInfo objectForKey:UIKeyboardIsLocalUserInfoKey] boolValue];
                      return curInfo;
                  }]
                 replayLazily]
                 takeUntil:self.rac_willDeallocSignal];
    
    [self sui_setAssociatedObject:curSignal key:_cmd policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    return curSignal;
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


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  PerformedOnce
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - PerformedOnce

- (void)sui_performOnce:(void (^)(void))cb key:(NSString *)cKey
{
    NSMutableArray *performedArray = [self sui_performedArray];
    if (![performedArray containsObject:cKey])
    {
        [performedArray addObject:cKey];
        cb();
    }
}

- (NSMutableArray *)sui_performedArray
{
    NSMutableArray *curArray = [self sui_getAssociatedObjectWithKey:_cmd];
    if (curArray) return curArray;
    
    curArray = [NSMutableArray array];
    [self sui_setAssociatedObject:curArray key:_cmd policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    return curArray;
}


@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIKeyboardInfo
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@implementation SUIKeyboardInfo : NSObject


- (CGFloat)keyboardHeight
{
    return self.frameEnd.size.height;
}


@end
