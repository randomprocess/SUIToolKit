//
//  SUIImagePicker.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/9/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SUIImagePicker : NSObject <
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate>


- (void)showCameraWithAnimated:(BOOL)flag;

- (void)showPhotoLibraryWithAnimated:(BOOL)flag;

@end


@interface UIViewController (SUIImagePicker)

@property (nonatomic,strong) SUIImagePicker *imagePicker;

@end
