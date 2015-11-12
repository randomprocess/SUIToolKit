//
//  NSObject+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/19.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "NSObject+SUIExt.h"
#import <objc/runtime.h>
#import "SUIToolKitConst.h"
#import "ReactiveCocoa.h"


@implementation NSObject (SUIExt)

@end


@implementation NSObject (SUIKeyboard)

- (void)suiRegisterForKeyboardNotifications
{
    if (self.hasRegisterForKeyboardNotifications) return;
    
    uWeakSelf
    [[gNotificationCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
    subscribeNext:^(NSNotification *cNoti) {
        [weakSelf suiKeyboardWillShowHide:YES noti:cNoti];
    }];
    
    [[gNotificationCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
     subscribeNext:^(NSNotification *cNoti) {
         [weakSelf suiKeyboardWillShowHide:NO noti:cNoti];
     }];
}

- (void)suiKeyboardWillShowHide:(BOOL)showKeyboard noti:(NSNotification *)cNoti
{
    CGRect keyboardRect = [[cNoti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    double duration = [[cNoti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [[cNoti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if (self.suiKeyboardWillChangeBlock) {
        if (showKeyboard) {
            self.suiKeyboardWillChangeBlock(showKeyboard, keyboardHeight, options, duration);
        } else {
            self.suiKeyboardWillChangeBlock(showKeyboard, 0, options, duration);
        }
    }
}

- (void)setSuiKeyboardHasRegisterForKeyboardNotifications:(BOOL)hasRegisterForKeyboardNotifications
{
    objc_setAssociatedObject(self, @selector(hasRegisterForKeyboardNotifications), @(hasRegisterForKeyboardNotifications), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)hasRegisterForKeyboardNotifications
{
    return [objc_getAssociatedObject(self, @selector(hasRegisterForKeyboardNotifications)) boolValue];
}

- (void)setSuiKeyboardWillChangeBlock:(SUIKeyboardWillChangeBlock)suiKeyboardWillChangeBlock
{
    objc_setAssociatedObject(self, @selector(suiKeyboardWillChangeBlock), suiKeyboardWillChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (SUIKeyboardWillChangeBlock)suiKeyboardWillChangeBlock
{
    return objc_getAssociatedObject(self, @selector(suiKeyboardWillChangeBlock));
}

- (void)suiKeyboardWillChange:(SUIKeyboardWillChangeBlock)cb
{
    [self suiRegisterForKeyboardNotifications];
    [self setSuiKeyboardWillChangeBlock:cb];
}

@end


@implementation NSObject (SUINetworkStatusChange)

- (void)suiRegisterForNetworkStatusNotifications
{
    [gNotificationCenter addObserver:self
                            selector:@selector(suiNetworkStatusChanged:)
                                name:SUINetworkingReachabilityDidChangeNotification
                              object:nil];
    
    uWeakSelf
    [[self rac_willDeallocSignal] subscribeCompleted:^{
        [gNotificationCenter removeObserver:weakSelf
                                       name:SUINetworkingReachabilityDidChangeNotification
                                     object:nil];
    }];
}

- (void)suiNetworkStatusChanged:(NSNotification *)cNoti
{
    if (self.suiNetworkStatusDidChangeBlock) {
        self.suiNetworkStatusDidChangeBlock([SUITool networkStatus], [cNoti.object integerValue]);
    }
}

- (void)setSuiNetworkStatusDidChangeBlock:(SUINetworkStatusDidChangeBlock)suiNetworkStatusDidChangeBlock
{
    objc_setAssociatedObject(self, @selector(suiNetworkStatusDidChangeBlock), suiNetworkStatusDidChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (SUINetworkStatusDidChangeBlock)suiNetworkStatusDidChangeBlock
{
    return objc_getAssociatedObject(self, @selector(suiNetworkStatusDidChangeBlock));
}

- (void)suiNetworkStatusDidChange:(SUINetworkStatusDidChangeBlock)cb
{
    [self suiRegisterForNetworkStatusNotifications];
    [self setSuiNetworkStatusDidChangeBlock:cb];
}

@end
