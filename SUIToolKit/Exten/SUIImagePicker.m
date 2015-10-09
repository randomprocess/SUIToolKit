//
//  SUIImagePicker.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/9/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SUIToolKitConst.h"
#import "SUITool.h"

@interface SUIImagePicker ()

@property (nonatomic,weak) UIViewController *srcVC;
@property (nonatomic,copy) SUIImagePickerCompletionBlock completionBlock;

@end

@implementation SUIImagePicker


- (void)showOnPickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType animated:(BOOL)flag completion:(SUIImagePickerCompletionBlock)cb
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        cb(YES, nil, nil);
        return;
    }
    
    self.completionBlock = cb;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    imagePickerController.editing = YES;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [self.srcVC presentViewController:imagePickerController
                             animated:flag
                           completion:^{
                           }];
}

- (void)dismissPickerViewController:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  UIImagePickerControllerDelegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if (self.completionBlock) self.completionBlock(NO, image, editingInfo);
    [self dismissPickerViewController:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.completionBlock) self.completionBlock(NO, nil, info);
    [self dismissPickerViewController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissPickerViewController:picker];
}

@end


@implementation UIViewController (SUIImagePicker)

- (SUIImagePicker *)imagePicker
{
    id curImagePicker = objc_getAssociatedObject(self, @selector(imagePicker));
    if (curImagePicker) return curImagePicker;
    
    SUIImagePicker *currImagePicker = [SUIImagePicker new];
    currImagePicker.srcVC = self;
    self.imagePicker = currImagePicker;
    return currImagePicker;
}

- (void)setImagePicker:(SUIImagePicker *)imagePicker
{
    objc_setAssociatedObject(self, @selector(imagePicker), imagePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end