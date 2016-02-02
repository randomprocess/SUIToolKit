//
//  UINavigationController+SUIAdditions.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/2.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (SUIAdditions)


@property (nonatomic) IBInspectable BOOL sui_setup;

@property (nullable,nonatomic,copy) IBInspectable NSString *sui_storyboardNameAndID;


@end

NS_ASSUME_NONNULL_END
