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

@protocol SUIMVVMVCProtocol <NSObject>
@optional

- (Class)sui_classOfViewModel;
- (void)sui_bindWithViewModel:(SUIViewModel *)sui_vm;

@end

@interface UIViewController (SUIMVVM) <SUIMVVMVCProtocol>


@property (readonly,nonatomic,strong) __kindof SUIViewModel *sui_vm;


@end

NS_ASSUME_NONNULL_END
