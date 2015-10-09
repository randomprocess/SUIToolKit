//
//  SUIImagePicker.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/9/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SUIImagePickerCompletionBlock)(BOOL cancel, UIImage *cImage, NSDictionary *cInfoDict);


@interface SUIImagePicker : NSObject <
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate>

- (void)showOnPickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType animated:(BOOL)flag completion:(SUIImagePickerCompletionBlock)cb;

@end


@interface UIViewController (SUIImagePicker)

@property (nonatomic,strong) SUIImagePicker *imagePicker;

@end
