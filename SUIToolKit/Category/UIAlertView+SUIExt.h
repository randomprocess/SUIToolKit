//
//  UIAlertView+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/5.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SUIAlertClickBlock)(NSInteger idx);

@interface UIAlertView (SUIExt)

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitle:(NSString *)otherButtonTitle
                    clickBlock:(SUIAlertClickBlock)clickBlock;


@end
