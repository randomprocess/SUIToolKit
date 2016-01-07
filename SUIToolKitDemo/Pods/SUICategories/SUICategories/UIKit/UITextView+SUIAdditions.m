//
//  UITextView+SUIAdditions.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/31.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "UITextView+SUIAdditions.h"

@implementation UITextView (SUIAdditions)


- (BOOL)sui_showKeyboard
{
    if (![self isFirstResponder])
    {
        return [self becomeFirstResponder];
    }
    return YES;
}
- (void)setSui_showKeyboard:(BOOL)sui_showKeyboard
{
    if (sui_showKeyboard && ![self isFirstResponder])
    {
        [self becomeFirstResponder];
    }
}

- (void)sui_dismissKeyboard
{
    if (self.isFirstResponder)
    {
        [self resignFirstResponder];
    }
}


@end
