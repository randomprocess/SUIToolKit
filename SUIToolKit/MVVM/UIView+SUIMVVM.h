//
//  UIView+SUIMVVM.h
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SUIViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol SUIMVVMViewProtocol <NSObject>
@optional

- (Class)sui_classOfViewModel;
- (void)sui_bindWithViewModel;

@end

@interface UIView (SUIMVVM) <SUIMVVMViewProtocol>


@property (readonly,nonatomic,strong) __kindof SUIViewModel *sui_vm;


@end

NS_ASSUME_NONNULL_END
