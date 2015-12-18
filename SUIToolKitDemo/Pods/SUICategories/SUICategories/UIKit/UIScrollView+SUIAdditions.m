//
//  UIScrollView+SUIAdditions.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/1.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UIScrollView+SUIAdditions.h"

@implementation UIScrollView (SUIAdditions)


- (void)sui_scrollToTopAnimated:(BOOL)animated
{
    [self setContentOffset:CGPointZero animated:animated];
}

- (void)sui_scrollToBottomAnimated:(BOOL)animated
{
    CGPoint curOffset = CGPointMake(0.0f, self.contentSize.height - self.bounds.size.height);
    [self setContentOffset:curOffset animated:animated];
}


@end
