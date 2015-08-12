//
//  SUIKeyboardFollowView.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/11.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIKeyboardFollowView.h"
#import "SUIToolKitConst.h"
#import "UIView+SUIExt.h"
#import "SUITool.h"

@interface SUIKeyboardFollowView ()

@property (nonatomic,strong) NSLayoutConstraint *currContantBottom;

@end

@implementation SUIKeyboardFollowView

- (void)awakeFromNib
{
    NSAssert([self contantHeight] != nil, @"should add contantHeight");
    
    self.originHeight = [self contantHeight].constant;
    
    uWeakSelf
    [SUITool keyboardWillChange:self cb:^(BOOL showKeyborad, CGFloat keyboardHeight, UIViewAnimationOptions options, double duration) {
        [UIView animateWithDuration:duration
                              delay:0
                            options:options
                         animations:^{
                             [weakSelf currContantBottom].constant = keyboardHeight;
                             [weakSelf layoutIfNeeded];
                         } completion:^(BOOL finished) {
                         }];
    }];
}

- (NSLayoutConstraint *)currContantBottom
{
    if (!_currContantBottom)
    {
        _currContantBottom = [self contantBottom];
        if (!_currContantBottom) {
            _currContantBottom = [self contantTop];
        }
        NSAssert(_currContantBottom != nil, @"should add contantBottom");
    }
    return _currContantBottom;
}

- (void)dealloc
{
    [SUITool keyboardRemoveWillChangeBlock:self];
}


@end
