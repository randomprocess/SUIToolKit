//
//  UITabBarItem+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/15.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (SUIExt)


@property (nonatomic,strong) IBInspectable UIImage *originalSelectedImage;

@property (nonatomic,copy) IBInspectable UIColor *normalTitleColo;

@property (nonatomic,copy) IBInspectable UIColor *selectedTitleColo;


@end
