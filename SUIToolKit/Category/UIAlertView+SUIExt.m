//
//  UIAlertView+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/5.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIAlertView+SUIExt.h"
#import "SUIToolKitConst.h"
#import <objc/runtime.h>

@interface SUIAlertViewDelegate : NSObject <UIAlertViewDelegate>

@property (nonatomic,copy) SUIAlertClickBlock clickBlock;

@end

@implementation SUIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickBlock)
    {
        uLog(@"alertView ButtonIndex ⤭ %zd ⤪", buttonIndex);
        self.clickBlock(buttonIndex);
        self.clickBlock = nil;
    }
}

@end


@implementation UIAlertView (SUIExt)


+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitle:(NSString *)otherButtonTitle
                    clickBlock:(SUIAlertClickBlock)clickBlock
{
    SUIAlertViewDelegate *curDelegate = [SUIAlertViewDelegate new];
    curDelegate.clickBlock = clickBlock;
    
    UIAlertView *curAlert = [[UIAlertView alloc]
                             initWithTitle:title
                             message:message
                             delegate:curDelegate
                             cancelButtonTitle:cancelButtonTitle
                             otherButtonTitles:otherButtonTitle, nil];
    
    [curAlert setAlertViewDelegate:curDelegate];
    
    [curAlert show];
    return curAlert;
}


- (void)setAlertViewDelegate:(SUIAlertViewDelegate *)alertViewDelegate
{
    objc_setAssociatedObject(self, @selector(alertViewDelegate), alertViewDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SUIAlertViewDelegate *)alertViewDelegate
{
    return objc_getAssociatedObject(self, @selector(alertViewDelegate));
}

@end
