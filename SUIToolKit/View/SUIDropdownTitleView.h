//
//  SUIDropdownTitleView.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/3.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUIDropdownTitleView : NSObject

@property (nonatomic,weak) IBOutlet UIViewController *currVC;


/** default is Black */
@property (nonatomic,assign) IBInspectable UIColor *titleColo;


@end
