//
//  SUIAdaptTextView.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/11.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseView.h"

@class SUIAdaptTextView;

typedef BOOL (^SUIAdaptTextViewReturnBlock)(void);
typedef void (^SUIAdaptTextViewHeightDidChangeBlock)(CGFloat newHeight);

@interface SUIAdaptTextView : SUIBaseView


@property (nonatomic) IBInspectable NSInteger maxLines; // Default is 4

@property (nonatomic) IBInspectable NSString *placeholder; // Default is nil


@property (nonatomic, copy) NSString *text;



- (void)showKeyboard;

- (void)dismissKeyboard;

- (void)returnKeyboard:(SUIAdaptTextViewReturnBlock)cb;

- (void)heightDidChange:(SUIAdaptTextViewHeightDidChangeBlock)cb;


@end
