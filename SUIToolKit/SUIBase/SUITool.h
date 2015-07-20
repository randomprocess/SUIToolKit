//
//  SUITool.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/20.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUITool : NSObject


#pragma mark - Init

+ (void)toolInit;


#pragma mark - Launched

+ (BOOL)firstLaunched;

+ (NSString *)everVersion;


#pragma mark - Keyboard

+ (BOOL)keyboardShow;

+ (CGFloat)keyboardHeight;

+ (double)keyboardAnimationDuration;


#pragma mark - File

+ (BOOL)fileCreateDirectory:(NSString *)filePath;

+ (BOOL)fileExist:(NSString *)filePath;

+ (BOOL)fileWrite:(NSData *)data atPath:(NSString *)filePath;

+ (NSData *)fileRead:(NSString *)filePath;

+ (NSUInteger)fileSize:(NSString *)filePath;

+ (BOOL)fileDelete:(NSString *)filePath;


#pragma mark - Camera

+ (BOOL)cameraAvailable;

+ (BOOL)cameraRearAvailable;

+ (BOOL)cameraFrontAvailable;

+ (BOOL)photoLibraryAvailable;


@end
