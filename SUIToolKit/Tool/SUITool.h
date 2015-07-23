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


#define mark - Unique identifier

+ (NSString *)uuidString;

+ (NSString *)idfvString;


#pragma mark - File Manager

+ (BOOL)fileCreateDirectory:(NSString *)filePath;

+ (BOOL)fileExist:(NSString *)filePath;

+ (BOOL)fileWrite:(NSData *)data toPath:(NSString *)filePath;

+ (BOOL)fileMove:(NSString *)sourcePath toPath:(NSString *)filePath;

+ (BOOL)fileCopy:(NSString *)sourcePath toPath:(NSString *)filePath;

+ (NSData *)fileRead:(NSString *)filePath;

+ (NSUInteger)fileSize:(NSString *)filePath;

+ (BOOL)fileDelete:(NSString *)filePath;


#pragma mark - Camera & PhotoLibrary

+ (BOOL)cameraAvailable;

+ (BOOL)cameraRearAvailable;

+ (BOOL)cameraFrontAvailable;

+ (BOOL)photoLibraryAvailable;


#pragma mark - Others

+ (BOOL)goToAppStore:(NSString *)appId;


typedef void (^SUIDelayTask)(BOOL cancel);

+ (SUIDelayTask)delay:(NSTimeInterval)delayInSeconds cb:(void (^)(void))completionBlock;

+ (void)cancelDelayTask:(SUIDelayTask)currTask;


@end
