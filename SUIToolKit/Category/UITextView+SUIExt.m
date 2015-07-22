//
//  UITextView+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/22.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UITextView+SUIExt.h"

@implementation UITextView (SUIExt)


- (void)setShowKeyboard:(BOOL)showKeyboard
{
    if (showKeyboard && ![self isFirstResponder])
    {
        [self becomeFirstResponder];
    }
}

- (BOOL)showKeyboard
{
    return [self isFirstResponder];
}


@end
