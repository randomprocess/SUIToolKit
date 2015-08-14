//
//  SUIAdaptTextView.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/11.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseView.h"


typedef BOOL (^SUIAdaptTextViewReturnBlock)(UITextView *textView);

@interface SUIAdaptTextView : SUIBaseView


@property (nonatomic) IBInspectable NSInteger maxLines; // Default is 4

@property (nonatomic) IBInspectable NSString *placeholder; // Default is nil


@property (nonatomic, copy) NSString *text;



- (void)showKeyboard;

- (void)dissmissKeyboard;

- (void)returnKeyboard:(SUIAdaptTextViewReturnBlock)returnBlock;



@end
