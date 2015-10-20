//
//  NSObject+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/19.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUITool.h"

typedef void (^SUIKeyboardWillChangeBlock)(BOOL showKeyboard, CGFloat keyboardHeight, UIViewAnimationOptions options, double duration);
typedef void (^SUINetworkStatusDidChangeBlock)(SUINetworkStatus everStatu, SUINetworkStatus currStatu);


@interface NSObject (SUIExt)

@end


@interface NSObject (SUIKeyboard)

- (void)suiKeyboardWillChange:(SUIKeyboardWillChangeBlock)cb;

@end


@interface NSObject (SUINetworkStatus)

- (void)suiNetworkStatusDidChange:(SUINetworkStatusDidChangeBlock)cb;

@end
