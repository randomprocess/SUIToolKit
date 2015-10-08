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

@end

@implementation SUIImagePicker


- (void)showCameraWithAnimated:(BOOL)flag
{
    if ([SUITool cameraAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([SUITool cameraRearAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self.srcVC presentViewController:controller
                                 animated:flag
                               completion:^{
                               }];
    }
}

- (void)showPhotoLibraryWithAnimated:(BOOL)flag
{
    if ([SUITool photoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([SUITool cameraRearAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self.srcVC presentViewController:controller
                                 animated:flag
                               completion:^{
                               }];
    }
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  UIImagePickerControllerDelegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
//    UIImage *portraitImg = [editingInfo objectForKey:@"UIImagePickerControllerOriginalImage"];

    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [picker dismissViewControllerAnimated:YES completion:^(){
//    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    uFun
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