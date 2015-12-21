//
//  UITableViewCell+SUIMVVM.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SUIViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (SUIMVVM)

@property (nonatomic,weak) __kindof SUIViewModel *sui_vm;

@end

NS_ASSUME_NONNULL_END
