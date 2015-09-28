//
//  SUIKeyboardFollowView.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/11.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseView.h"

@interface SUIKeyboardFollowView : SUIBaseView


@property (nonatomic,readonly,assign) CGFloat originHeight;

- (NSLayoutConstraint *)currContantBottom;

- (void)bottomContant:(CGFloat)constant;

@end
