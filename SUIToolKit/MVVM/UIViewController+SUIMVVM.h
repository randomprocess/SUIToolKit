//
//  UIViewController+SUIMVVM.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SUIViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SUIMVVM)

@property (null_resettable,copy) __kindof SUIViewModel *sui_vm;

@end

NS_ASSUME_NONNULL_END
