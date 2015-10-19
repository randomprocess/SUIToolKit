//
//  SUITool.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/20.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SUINetworkStatus) {
    SUINetworkStatusUnknown             = -1,
    SUINetworkStatusNotReachable        = 0,
    SUINetworkStatusReachableViaWWAN    = 1,
    SUINetworkStatusReachableViaWiFi    = 2
};

#define SUINetworkingReachabilityDidChangeNotification @"com.suio.network.reachability.change"

typedef void (^SUIDelayTask)(BOOL cancel);
typedef void (^SUIAppStoreVersionCompletionBlock)(NSError *error, NSString *appVersion);


@interface SUITool : NSObject

#pragma mark - Init

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Init
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (void)toolInit;


#pragma mark - Launched

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Launched
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (BOOL)firstLaunched;

+ (NSString *)everVersion;


#pragma mark - Network reachable

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Network reachable
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (SUINetworkStatus)networkStatus;


#pragma mark - Keyboard property

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Keyboard property
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (BOOL)keyboardShow;

+ (CGFloat)keyboardHeight;

+ (double)keyboardAnimationDuration;

+ (UIViewAnimationOptions)keyboardAnimationOptions;


#pragma mark - Unique identifier

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Unique identifier
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (NSString *)uuidString;

+ (NSString *)idfvString;


#pragma mark - File manager

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  File manager
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (BOOL)fileCreateDirectory:(NSString *)filePath;

+ (BOOL)fileExist:(NSString *)filePath;

+ (BOOL)fileWrite:(NSData *)data toPath:(NSString *)filePath;

+ (BOOL)fileMove:(NSString *)sourcePath toPath:(NSString *)filePath;

+ (BOOL)fileCopy:(NSString *)sourcePath toPath:(NSString *)filePath;

+ (NSData *)fileRead:(NSString *)filePath;

+ (NSUInteger)fileSize:(NSString *)filePath;

+ (BOOL)fileDelete:(NSString *)filePath;


#pragma mark - Camera & PhotoLibrary

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Camera & PhotoLibrary
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (BOOL)cameraAvailable;

+ (BOOL)cameraRearAvailable;

+ (BOOL)cameraFrontAvailable;

+ (BOOL)photoLibraryAvailable;


#pragma mark - Others

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Others
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (BOOL)goToAppStore:(NSString *)appId;

+ (void)appStoreVersion:(NSString *)appId cb:(SUIAppStoreVersionCompletionBlock)completionBlock;

+ (SUIDelayTask)delay:(NSTimeInterval)delayInSeconds cb:(void (^)(void))completionBlock;

+ (void)cancelDelayTask:(SUIDelayTask)currTask;


@end
