//
//  UIScrollView+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/14.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIScrollView+SUIExt.h"

@implementation UIScrollView (SUIExt)


- (void)fitContentSize
{
    CGRect curRect = CGRectZero;
    
    for (UIView *iView in [self subviews])
    {
        curRect = CGRectUnion(curRect, iView.frame);
    }
    
    self.contentSize = curRect.size;
}

@end
