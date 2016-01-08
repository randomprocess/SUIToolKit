//
//  SUIToolbar.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/31.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUIToolbar : UIView


@property (nonatomic) IBInspectable BOOL onTopOfKeyboard;

@property (nonatomic,strong) IBOutlet UIView *topOfView;

@property (nonatomic) IBInspectable double viewsAnimationDuration;


- (void)updateWithTopOfView;


@end

NS_ASSUME_NONNULL_END
