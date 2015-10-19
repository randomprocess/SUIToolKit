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
    
    [gNotificationCenter addObserver:self
                            selector:@selector(suiKeyboardWillShow:)
                                name:UIKeyboardWillShowNotification
                              object:nil];
    
    [gNotificationCenter addObserver:self
                            selector:@selector(suiKeyboardWillHide:)
                                name:UIKeyboardWillHideNotification
                              object:nil];
    
    uWeakSelf
    [[self rac_willDeallocSignal] subscribeCompleted:^{
        [gNotificationCenter removeObserver:weakSelf
                                       name:UIKeyboardWillShowNotification
                                     object:nil];
        
        [gNotificationCenter removeObserver:weakSelf
                                       name:UIKeyboardWillHideNotification
                                     object:nil];
    }];
}

- (void)suiKeyboardWillShow:(NSNotification *)cNoti
{
    [self suiKeyboardWillShowHide:YES noti:cNoti];
}
- (void)suiKeyboardWillHide:(NSNotification *)cNoti
{
    [self suiKeyboardWillShowHide:NO noti:cNoti];
}

- (void)suiKeyboardWillShowHide:(BOOL)showKeyborad noti:(NSNotification *)cNoti
{
    CGRect keyboardRect = [[cNoti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    UIViewAnimationOptions options = [[cNoti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    double duration = [[cNoti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if (self.suiKeyboardWillChangeBlock) {
        self.suiKeyboardWillChangeBlock(showKeyborad, keyboardHeight, options, duration);
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
