//
//  UIButton+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/23.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SUIButtonClickBlock)(void);

typedef NS_ENUM(NSInteger, SUIButtonFlashType) {
    SUIButtonFlashTypeNormal = 0,
    SUIButtonFlashTypeInner = 1,
    SUIButtonFlashTypeOuter = 2
};

@interface UIButton (SUIExt)


+ (instancetype)customBtn;

// _____________________________________________________________________________

@property (nonatomic,copy) NSString *normalTitle;
@property (nonatomic,strong) UIColor *normalTitleColor;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *normalBackgroundImage;

// _____________________________________________________________________________

@property (nonatomic,copy) NSString *pressedTitle;
@property (nonatomic,strong) UIColor *pressedTitleColor;
@property (nonatomic,strong) UIImage *pressedImage;

// _____________________________________________________________________________

@property (nonatomic,copy) NSString *selectedTitle;
@property (nonatomic,strong) UIColor *selectedTitleColor;
@property (nonatomic,strong) UIImage *selectedImage;

// _____________________________________________________________________________

@property (nonatomic,copy) NSString *disabledTitle;
@property (nonatomic,strong) UIColor *disabledTitleColor;
@property (nonatomic,strong) UIImage *disabledImage;

// _____________________________________________________________________________

@property (nonatomic,assign) CGFloat padding;
@property (nonatomic,assign) UIEdgeInsets insets;

// _____________________________________________________________________________

@property (nonatomic,assign) SUIButtonFlashType flashType;
@property (nonatomic,strong) UIColor *flashColor;

// _____________________________________________________________________________

@property (nonatomic,copy) SUIButtonClickBlock clickBlock;


@end
