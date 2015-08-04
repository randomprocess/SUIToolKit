//
//  SUIDropdownTitleMenu.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/4.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUIDropdownTitleMenu : NSObject


@property (nonatomic,weak) IBOutlet UIViewController *currVC;


/** default is gRGB(40, 196, 80) */
@property (nonatomic,assign) IBInspectable UIColor *backgroundColo;

/** default is Black */
@property (nonatomic,assign) IBInspectable UIColor *titleColo;


@end
