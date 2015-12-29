//
//  SUITool.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/11/25.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUITool.h"
#import <UIKit/UIKit.h>
#import "SUIMacros.h"

NSString *const sui_everLaunched = @"sui_everLaunched";
NSString *const sui_everVersion = @"sui_everVersion";


@interface SUITool ()

@property (nonatomic,assign) SUILaunchedType launchedType;


@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Launched
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@implementation SUITool (SUILaunch)

- (void)updateVersion
{
    if (gUserDefaultsBoolForKey(sui_everLaunched))
    {
        NSString *cVersion = kVersion;
        NSString *eVersion = [self previousVersion];
        
        if ([eVersion isEqualToString:cVersion]) {
            self.launchedType = SUILaunchedTypeLatestVersion;
            uLogInfo(@"ever launched latest-version CurrVersion ⤭ %@ ⤪", cVersion);
        }
        else
        {
            [gUserDefaults setObject:cVersion forKey:sui_everVersion];
            [gUserDefaults synchronize];
            
            self.launchedType = SUILaunchedTypeUpdateVersion;
            uLogInfo(@"ever launched update-version EverVersion ⤭ %@ ⤪  CurrVersion ⤭ %@ ⤪", eVersion, cVersion);
        }
    }
    else
    {
        [gUserDefaults setBool:YES forKey:sui_everLaunched];
        [gUserDefaults setObject:kVersion forKey:sui_everVersion];
        [gUserDefaults synchronize];
        
        self.launchedType = SUILaunchedTypeFirstLaunched;
        uLogInfo(@"first launched CurrVersion ⤭ %@ ⤪", kVersion);
    }
}

- (NSString *)previousVersion
{
    return gUserDefaultsObjForKey(sui_everVersion);
}

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Tool
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@implementation SUITool


#pragma mark - Init

uSharedInstanceWithCommonInit

- (void)commonInit
{
    [self updateVersion];
}


#pragma mark - Launched

+ (SUILaunchedType)launchedType
{
    return [[self sharedInstance] launchedType];
}

+ (NSString *)previousVersion
{
    return [[self sharedInstance] previousVersion];
}


#pragma mark - File manager

+ (BOOL)fileCreateDirectory:(NSString *)filePath
{
    if (![self fileExist:filePath])
    {
        NSError *anyError = nil;
        BOOL ret = [[NSFileManager defaultManager]
                    createDirectoryAtPath:filePath
                    withIntermediateDirectories:YES
                    attributes:nil
                    error:&anyError];
        
        uAssert(ret, @"file create director Error ⤭ %@ ⤪  At ⤭ %@ ⤪", anyError, filePath);
        return ret;
    }
    return YES;
}

+ (BOOL)fileExist:(NSString *)filePath
{
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return ret;
}

+ (BOOL)fileWrite:(NSData *)data toPath:(NSString *)filePath
{
    NSError *anyError = nil;
    BOOL ret = [data writeToFile:filePath
                         options:NSDataWritingAtomic
                           error:&anyError];

    uAssert(ret, @"file write Error ⤭ %@ ⤪  To ⤭ %@ ⤪", anyError, filePath);
    return ret;
}

+ (BOOL)fileMove:(NSString *)sourcePath toPath:(NSString *)filePath
{
    NSError *anyError = nil;
    BOOL ret = [[NSFileManager defaultManager]
                moveItemAtPath:sourcePath
                toPath:filePath
                error:&anyError];

    uAssert(ret, @"file move Error ⤭ %@ ⤪  Source ⤭ %@ ⤪  To ⤭ %@ ⤪", anyError, sourcePath, filePath);
    return ret;
}

+ (BOOL)fileCopy:(NSString *)sourcePath toPath:(NSString *)filePath
{
    NSError *anyError = nil;
    BOOL ret = [[NSFileManager defaultManager]
                copyItemAtPath:sourcePath
                toPath:filePath
                error:&anyError];

    uAssert(ret, @"file copy Error ⤭ %@ ⤪  Source ⤭ %@ ⤪  To ⤭ %@ ⤪", anyError, sourcePath, filePath);
    return ret;
}

+ (NSData *)fileRead:(NSString *)filePath
{
    NSError *anyError = nil;
    NSData *readData = [NSData dataWithContentsOfFile:filePath
                                              options:NSDataReadingMappedIfSafe
                                                error:&anyError];

    uAssert(!anyError, @"file read Error ⤭ %@ ⤪  At ⤭ %@ ⤪", anyError, filePath);
    return readData;
}

+ (NSUInteger)fileSize:(NSString *)filePath
{
    if ([self fileExist:filePath])
    {
        NSError *anyError = nil;
        NSDictionary *attributes = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:filePath
                                    error:&anyError];
        if (!anyError) {
            NSInteger fSize = [[attributes objectForKey:NSFileSize] integerValue];
            return fSize;
        } else {
            uLogError(@"file size Error ⤭ %@ ⤪  At ⤭ %@ ⤪", anyError, filePath);
        }
    }
    return 0;
}

+ (BOOL)fileDelete:(NSString *)filePath
{
    if ([self fileExist:filePath])
    {
        NSError *anyError = nil;
        BOOL ret = [[NSFileManager defaultManager]
                    removeItemAtPath:filePath
                    error:&anyError];

        uAssert(ret, @"file delete Error ⤭ %@ ⤪  At ⤭ %@ ⤪", anyError, filePath);
        return ret;
    }
    return YES;
}


#pragma mark - Unique identifier

+ (NSString *)uuidString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    NSString *curUUID = (__bridge_transfer NSString*)
    CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *currUUID = [[curUUID lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    uLogInfo(@"uuid ⤭ %@ ⤪", currUUID);
    return currUUID;
}

+ (NSString *)idfvString
{
    NSString *curIdfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *currIdfv = [[curIdfv lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    uLogInfo(@"idfv ⤭ %@ ⤪", currIdfv);
    return currIdfv;
}


#pragma mark - Camera & PhotoLibrary

+ (BOOL)cameraAvailable
{
    BOOL ret = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

    uAssert(ret, @"cameta unavailable");
    return ret;
}

+ (BOOL)cameraRearAvailable
{
    BOOL ret = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];

    uAssert(ret, @"ameta rear unavailable");
    return ret;
}

+ (BOOL)cameraFrontAvailable
{
    BOOL ret = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];

    uAssert(ret, @"cameta front unavailable");
    return ret;
}

+ (BOOL)photoLibraryAvailable
{
    BOOL ret = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];

    uAssert(ret, @"photo library unavailable");
    return ret;
}


#pragma mark - OpenURL

+ (BOOL)openMail:(NSString *)mail
{
    NSString *curURL = gFormat(@"mailto://%@", mail);
    BOOL ret =  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:curURL]];
    
    uAssert(ret, @"open mail failed Mail ⤭ %@ ⤪", mail);
    return ret;
}

+ (BOOL)openPhone:(NSString *)phone
{
    NSString *curURL = gFormat(@"telprompt://%@", phone);
    BOOL ret =  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:curURL]];
    
    uAssert(ret, @"open phone failed Phone ⤭ %@ ⤪", phone);
    return ret;
}

+ (BOOL)openAppStore:(NSString *)appId
{
    NSString *curURL = gFormat(@"itms-apps://itunes.apple.com/app/id%@", appId);
    BOOL ret = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:curURL]];
    
    uAssert(ret, @"open app store failed AppId ⤭ %@ ⤪", appId);
    return ret;
}


#pragma mark - Delay

+ (SUIToolDelayTask)delay:(NSTimeInterval)delay cb:(void (^)(void))completion;
{
    __block dispatch_block_t closure = completion;
    __block SUIToolDelayTask currTask = nil;
    
    SUIToolDelayTask delayedBlock = ^(BOOL cancel) {
        if (cancel == NO) {
            dispatch_async(dispatch_get_main_queue(), closure);
        }
        closure = nil;
        currTask = nil;
    };
    
    currTask = delayedBlock;
    
    [self sui_delayExecutive:delay cb:^{
        if (currTask) currTask(NO);
    }];
    return currTask;
}

+ (void)cancelDelayTask:(SUIToolDelayTask)cTask
{
    if (cTask) cTask(YES);
}

+ (void)sui_delayExecutive:(NSTimeInterval)delayInSeconds cb:(void (^)(void))completionBlock
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), completionBlock);
}


@end
