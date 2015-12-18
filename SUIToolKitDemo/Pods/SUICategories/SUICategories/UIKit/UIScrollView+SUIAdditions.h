//
//  UIScrollView+SUIAdditions.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/1.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (SUIAdditions)


- (void)sui_scrollToTopAnimated:(BOOL)animated;

- (void)sui_scrollToBottomAnimated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
