//
//  UIButton+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/23.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SUIExt)


+ (UIButton *)customBtn;

@property (nonatomic,copy) NSString *normalTitle;
@property (nonatomic,strong) UIColor *normalTitleColor;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *normalBackgroundImage;

@property (nonatomic,copy) NSString *pressedTitle;
@property (nonatomic,strong) UIColor *pressedTitleColor;
@property (nonatomic,strong) UIImage *pressedImage;

@property (nonatomic,copy) NSString *selectedTitle;
@property (nonatomic,strong) UIColor *selectedTitleColor;
@property (nonatomic,strong) UIImage *selectedImage;

@property (nonatomic,copy) NSString *disabledTitle;
@property (nonatomic,strong) UIColor *disabledTitleColor;
@property (nonatomic,strong) UIImage *disabledImage;


- (void)addClickTarget:(id)target action:(SEL)action;


@end
