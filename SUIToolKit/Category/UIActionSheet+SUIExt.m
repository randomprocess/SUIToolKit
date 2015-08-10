//
//  UIActionSheet+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/6.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIActionSheet+SUIExt.h"
#import "SUIToolKitConst.h"
#import <objc/runtime.h>

@interface SUIActionSheetDelegate : NSObject <UIActionSheetDelegate>

@property (nonatomic,copy) SUIActionClickBlock clickBlock;

@end

@implementation SUIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickBlock)
    {
        uLogInfo(@"actionSheet ButtonIndex ⤭ %zd ⤪", buttonIndex);
        if ([actionSheet cancelButtonIndex] == buttonIndex) {
            self.clickBlock(YES, buttonIndex);
        } else {
            self.clickBlock(NO, buttonIndex);
        }
        self.clickBlock = nil;
    }
}

@end

@implementation UIActionSheet (SUIExt)

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
                          clickBlock:(SUIActionClickBlock)clickBlock
{
    
    return [self actionSheetWithTitle:title
                    cancelButtonTitle:cancelButtonTitle
                    otherButtonTitles:otherButtonTitles
               destructiveButtonIndex:-1
                           clickBlock:clickBlock];
}


+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
              destructiveButtonIndex:(NSInteger)destructiveButtonIndex
                          clickBlock:(SUIActionClickBlock)clickBlock
{
    SUIActionSheetDelegate *curDelegate = [SUIActionSheetDelegate new];
    curDelegate.clickBlock = clickBlock;
    
    UIActionSheet *curAction = [[UIActionSheet alloc]
                                initWithTitle:title
                                delegate:curDelegate
                                cancelButtonTitle:cancelButtonTitle
                                destructiveButtonTitle:nil
                                otherButtonTitles:nil];
    
    for (NSString *curOtherTitles in otherButtonTitles) {
        [curAction addButtonWithTitle:curOtherTitles];
    }
    
    [curAction setActionSheetDelegate:curDelegate];
    curAction.destructiveButtonIndex = destructiveButtonIndex;
    [curAction showInView:gWindow];
    return curAction;
}


- (void)setActionSheetDelegate:(SUIActionSheetDelegate *)actionSheetDelegate
{
    objc_setAssociatedObject(self, @selector(actionSheetDelegate), actionSheetDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SUIActionSheetDelegate *)actionSheetDelegate
{
    return objc_getAssociatedObject(self, @selector(actionSheetDelegate));
}

@end
