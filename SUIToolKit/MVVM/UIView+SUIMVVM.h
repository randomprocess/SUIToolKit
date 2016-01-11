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

- (void)sui_bindWithViewModel:(nullable __kindof SUIViewModel *)sui_vm;

@end

@interface UIView (SUIMVVM) <SUIMVVMViewProtocol>


@property (nullable,nonatomic,copy) __kindof SUIViewModel *sui_vm;


@end

NS_ASSUME_NONNULL_END
