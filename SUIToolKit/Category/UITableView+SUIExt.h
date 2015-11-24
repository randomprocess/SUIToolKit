//
//  UITableView+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/19.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (SUIExt)


- (void)scrollToBottomWithAnimated:(BOOL)animated;

- (void)scrollToTopWithAnimated:(BOOL)animated;

- (void)contentInsertsWithBottomValue:(CGFloat)cBottom;


@end
