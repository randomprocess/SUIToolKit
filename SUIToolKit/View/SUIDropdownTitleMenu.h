//
//  SUIDropdownTitleMenu.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/4.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIPopupObject.h"


typedef NSArray *(^SUIDropdownTitleMenuTitlesBlock)(void);
typedef NSArray *(^SUIDropdownTitleMenuCustomViewsBlock)(void);
typedef void (^SUIDropdownTitleMenuDidSelectBlock)(NSInteger cIndex);

@interface SUIDropdownTitleMenu : SUIPopupObject

- (void)titles:(SUIDropdownTitleMenuTitlesBlock)cb;
- (void)customViews:(SUIDropdownTitleMenuCustomViewsBlock)cb;
- (void)didSelect:(SUIDropdownTitleMenuDidSelectBlock)cb;

@property (nonatomic,assign) IBInspectable UIColor *backgroundColo; // default is gRGB(40, 196, 80)
@property (nonatomic,assign) IBInspectable UIColor *titleColo; // default is Black

@end


@interface UIViewController (SUIDropdownTitleMenu)

@property (nonatomic,strong) SUIDropdownTitleMenu *dropdownTitleMenu;

@end