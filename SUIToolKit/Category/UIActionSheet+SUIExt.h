//
//  UIActionSheet+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/6.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SUIActionClickBlock)(BOOL cancel, NSInteger idx);

@interface UIActionSheet (SUIExt)

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
                          clickBlock:(SUIActionClickBlock)clickBlock;

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
              destructiveButtonIndex:(NSInteger)destructiveButtonIndex
                          clickBlock:(SUIActionClickBlock)clickBlock;

@end
