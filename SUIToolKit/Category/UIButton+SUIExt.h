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


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Normal
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@property (nonatomic,copy) NSString *normalTitle;
@property (nonatomic,strong) UIColor *normalTitleColo;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *normalBackgroundImage;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Highlighted
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@property (nonatomic,copy) NSString *pressedTitle;
@property (nonatomic,strong) UIColor *pressedTitleColo;
@property (nonatomic,strong) UIImage *pressedImage;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Selected
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@property (nonatomic,copy) NSString *selectedTitle;
@property (nonatomic,strong) UIColor *selectedTitleColo;
@property (nonatomic,strong) UIImage *selectedImage;
@property (nonatomic,strong) UIImage *selectedBackgroundImage;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Disabled
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@property (nonatomic,copy) NSString *disabledTitle;
@property (nonatomic,strong) UIColor *disabledTitleColo;
@property (nonatomic,strong) UIImage *disabledImage;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Padding & Insets
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@property (nonatomic,assign) CGFloat padding;
@property (nonatomic,assign) UIEdgeInsets insets;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Flash
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@property (nonatomic,assign) SUIButtonFlashType flashType;
@property (nonatomic,strong) UIColor *flashColo;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Click
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@property (nonatomic,copy) SUIButtonClickBlock clickBlock;


@end
