//
//  UITextView+SUIAdditions.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/31.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (SUIAdditions)


@property (nonatomic) IBInspectable BOOL sui_showKeyboard;

- (void)sui_dismissKeyboard;


@end

NS_ASSUME_NONNULL_END
