//
//  UITabBarItem+SUIAdditions.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/14.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (SUIAdditions)


@property (nullable,nonatomic,copy) IBInspectable UIImage *sui_originalSelectedImage;

@property (nonatomic,copy) IBInspectable UIColor *sui_normalTitleColo;

@property (nonatomic,copy) IBInspectable UIColor *sui_selectedTitleColo;


@end

NS_ASSUME_NONNULL_END
