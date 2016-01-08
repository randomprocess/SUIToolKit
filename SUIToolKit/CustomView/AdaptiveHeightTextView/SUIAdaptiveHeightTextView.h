//
//  SUIAdaptiveHeightTextView.h
//  SUIToolKitDemo
//
//  Created by zzZ on 16/1/7.
//  Copyright © 2016年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^SUIAdaptiveHeightTextViewShouldReturnBlock)(void);
typedef void (^SUIAdaptiveHeightTextViewHeightDidChangedBlock)(CGFloat newHeight);

@interface SUIAdaptiveHeightTextView : UIView


@property (nonatomic) IBInspectable NSInteger maxLines; // Default is 4
@property (nullable,nonatomic) IBInspectable NSString *placeholder; // Default is nil

- (void)shouldReturnKeyboard:(SUIAdaptiveHeightTextViewShouldReturnBlock)cb;
- (void)heightDidChanged:(SUIAdaptiveHeightTextViewHeightDidChangedBlock)cb;

@property (nonatomic,readonly,strong) UITextView *currTextView;
@property (nullable,nonatomic,strong) IBInspectable UIImage *backgroundImage;

@end

NS_ASSUME_NONNULL_END
