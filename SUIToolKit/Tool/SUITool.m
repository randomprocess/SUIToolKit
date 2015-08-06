//
//  SUITool.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/20.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUITool.h"
#import "SUIToolKitConst.h"
#import "SUIHttpClient.h"

NSString *const SUIEver_Launched = @"Ever_Launched";
NSString *const SUICurr_Version = @"Curr_Version";


// _____________________________________________________________________________

@interface SUITool ()

@property (nonatomic,assign,getter=isFirstLaunched) BOOL firstLaunched;
@property (nonatomic,copy) NSString *everVersion;

@property (nonatomic,assign,getter=isKeyboardShow) BOOL keyboardShow;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) double keyboardAnimationDuration;

@property (nonatomic,copy) SUIAppStoreVersionCompletionBlock appStoreVersionCompletion;

@end


// _____________________________________________________________________________

@implementation SUITool (SUILaunch)

- (void)updateVersion
{
    if (gUserDefaultsBoolForKey(SUIEver_Launched))
    {
        NSString *currVersion = kVersion;
        self.everVersion = gUserDefaultsObjForKey(SUICurr_Version);
        
        if ([self.everVersion isEqualToString:currVersion])
        {
            self.firstLaunched = NO;
            uLogInfo(@"ever launched non-update-version CurrVersion ⤭ %@ ⤪", currVersion);
        }
        else
        {
            [gUserDefaults setObject:currVersion forKey:SUICurr_Version];
            [gUserDefaults synchronize];
            
            self.firstLaunched = YES;
            uLogInfo(@"ever launched update-version EverVersion ⤭ %@ ⤪  CurrVersion ⤭ %@ ⤪", self.everVersion, currVersion);
        }
    }
    else
    {
        [gUserDefaults setBool:YES forKey:SUIEver_Launched];
        [gUserDefaults setObject:kVersion forKey:SUICurr_Version];
        [gUserDefaults synchronize];
        
        self.firstLaunched = YES;
        uLogInfo(@"first launched CurrVersion ⤭ %@ ⤪", kVersion);
    }
}

@end


// _____________________________________________________________________________

@implementation SUITool (SUIKeyboard)

- (void)listenKeyboard
{
    [gNotificationCenter addObserver:self
                            selector:@selector(keyboardWillShow:)
                                name:UIKeyboardWillShowNotification
                              object:nil];
    
    [gNotificationCenter addObserver:self
                            selector:@selector(keyboardWillHide:)
                                name:UIKeyboardWillHideNotification
                              object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    self.keyboardShow = YES;
    CGRect keyboardRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    self.keyboardAnimationDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    uLogInfo(@"keyboard will show Height > %f <", self.keyboardHeight);
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    self.keyboardShow = NO;
    self.keyboardHeight = 0;
    uLogInfo(@"keyboard will show hide");
}

@end


// _____________________________________________________________________________

@implementation SUITool

#pragma mark - Init

+ (instancetype)sharedInstance
{
    static SUITool *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[self alloc] init];
    });
    
    return sharedSingleton;
}

+ (void)toolInit
{
    [[self sharedInstance] commonInit];
}

- (void)commonInit
{
    [self updateVersion];
    
    [self listenKeyboard];
}


#pragma mark - Launched

+ (BOOL)firstLaunched
{
    return [[self sharedInstance] isFirstLaunched];
}

+ (NSString *)everVersion
{
    return [[self sharedInstance] everVersion];
}


#pragma mark - Keyboard

+ (BOOL)keyboardShow
{
    return [[self sharedInstance] isKeyboardShow];
}

+ (CGFloat)keyboardHeight
{
    return [[self sharedInstance] keyboardHeight];
}

+ (double)keyboardAnimationDuration
{
    return [[self sharedInstance] keyboardAnimationDuration];
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


#pragma mark - File Manager

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
        if (ret) {
            uLogInfo(@"file create director succeed At ⤭ %@ ⤪", filePath);
        } else {
            uLogError(@"file create director Error ⤭ %@ ⤪    At ⤭ %@ ⤪", anyError, filePath);
        }
        return ret;
    }
    return YES;
}

+ (BOOL)fileExist:(NSString *)filePath
{
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (ret) {
        uLogInfo(@"file exist At ⤭ %@ ⤪", filePath);
    } else {
        uLogInfo(@"file not exist At ⤭ %@ ⤪", filePath);
    }
    return ret;
}

+ (BOOL)fileWrite:(NSData *)data toPath:(NSString *)filePath
{
    NSError *anyError = nil;
    BOOL ret = [data writeToFile:filePath
                         options:NSDataWritingAtomic
                           error:&anyError];
    if (ret) {
        uLogInfo(@"file write succeed To ⤭ %@ ⤪", filePath);
    } else {
        uLogError(@"file write Error ⤭ %@ ⤪  To ⤭ %@ ⤪", anyError, filePath);
    }
    return ret;
}

+ (BOOL)fileMove:(NSString *)sourcePath toPath:(NSString *)filePath
{
    NSError *anyError = nil;
    BOOL ret = [[NSFileManager defaultManager]
                moveItemAtPath:sourcePath
                toPath:filePath
                error:&anyError];
    if (ret) {
        uLogInfo(@"file move succeed Source ⤭ %@ ⤪  To ⤭ %@ ⤪", sourcePath, filePath);
    } else {
        uLogError(@"file move Error ⤭ %@ ⤪  Source ⤭ %@ ⤪  To ⤭ %@ ⤪", anyError, sourcePath, filePath);
    }
    return ret;
}

+ (BOOL)fileCopy:(NSString *)sourcePath toPath:(NSString *)filePath
{
    NSError *anyError = nil;
    BOOL ret = [[NSFileManager defaultManager]
                copyItemAtPath:sourcePath
                toPath:filePath
                error:&anyError];
    if (ret) {
        uLogInfo(@"file copy succeed Source ⤭ %@ ⤪  To ⤭ %@ ⤪", sourcePath, filePath);
    } else {
        uLogError(@"file copy Error ⤭ %@ ⤪  Source ⤭ %@ ⤪  To ⤭ %@ ⤪", anyError, sourcePath, filePath);
    }
    return ret;
}

+ (NSData *)fileRead:(NSString *)filePath
{
    NSError *anyError = nil;
    NSData *readData = [NSData dataWithContentsOfFile:filePath
                                              options:NSDataReadingMappedIfSafe
                                                error:&anyError];
    if (!anyError) {
        uLogInfo(@"file read succeed Length ⤭ %zd ⤪  At ⤭ %@ ⤪", readData.length, filePath);
    } else {
        uLogError(@"file read Error ⤭ %@ ⤪  At ⤭ %@ ⤪", anyError, filePath);
    }
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
            uLogInfo(@"file size succeed Size ⤭ %zd ⤪  At ⤭ %@ ⤪", fSize, filePath);
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
        if (ret) {
            uLogInfo(@"file delete succeed At ⤭ %@ ⤪", filePath);
        } else {
            uLogError(@"file delete Error ⤭ %@ ⤪  At ⤭ %@ ⤪", anyError, filePath);
        }
        return ret;
    }
    return YES;
}



#pragma mark - Camera & PhotoLibrary

+ (BOOL)cameraAvailable
{
    BOOL ret = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (ret) {
        uLogInfo(@"camera available");
    } else {
        uLogInfo(@"cameta unavailable");
    }
    return ret;
}

+ (BOOL)cameraRearAvailable
{
    BOOL ret = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (ret) {
        uLogInfo(@"camera rear available");
    } else {
        uLogInfo(@"cameta rear unavailable");
    }
    return ret;
}

+ (BOOL)cameraFrontAvailable
{
    BOOL ret = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    if (ret) {
        uLogInfo(@"camera front available");
    } else {
        uLogInfo(@"cameta front unavailable");
    }
    return ret;
}

+ (BOOL)photoLibraryAvailable
{
    BOOL ret = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if (ret) {
        uLogInfo(@"photo library available");
    } else {
        uLogInfo(@"photo library unavailable");
    }
    return ret;
}



#pragma mark - Others

+ (BOOL)goToAppStore:(NSString *)appId
{
    NSString *curURL = gFormat(@"itms-apps://itunes.apple.com/app/id%@", appId);
    BOOL ret = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:curURL]];
    if (ret) {
        uLogInfo(@"to app store succeed AppId ⤭ %@ ⤪", appId);
    } else {
        uLogError(@"to app store failed AppId ⤭ %@ ⤪", appId);
    }
    
    return ret;
}

+ (void)appStoreVersion:(NSString *)appId cb:(SUIAppStoreVersionCompletionBlock)completionBlock
{
    if ([SUITool sharedInstance].appStoreVersionCompletion)
    {
        return;
    }
    
    [SUITool sharedInstance].appStoreVersionCompletion = completionBlock;
    
    [[SUIHttpClient sharedClient]
     requestWithHost:@"http://itunes.apple.com/lookup"
     httpMethod:@"GET"
     parameters:@{
                  @"id": appId
                  }
     completion:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         
         if (error == nil)
         {
             NSDictionary *dict = (NSDictionary *)responseObject;
             
             NSArray *resultsAry = dict[@"results"];
             NSDictionary *resultDic = resultsAry[0];
             
             NSString *appVersion = resultDic[@"version"];
             
             uLogInfo("AppVersion ⤭ %@ ⤪  CurrVersion ⤭ %@ ⤪", responseObject, kVersion);
             
             [SUITool sharedInstance].appStoreVersionCompletion(nil, appVersion);
         }
         else
         {
             uLogError(@"appStore version Error ⤭ %@ ⤪", error);
             
             [SUITool sharedInstance].appStoreVersionCompletion(error, nil);
         }
         [SUITool sharedInstance].appStoreVersionCompletion = nil;
     }];
    
}


+ (SUIDelayTask)delay:(NSTimeInterval)delayInSeconds cb:(void (^)(void))completionBlock
{
    __block dispatch_block_t closure = completionBlock;
    __block SUIDelayTask currTask = nil;
    
    SUIDelayTask delayedBlock = ^(BOOL cancel) {
        
        if (cancel == NO)
        {
            dispatch_async(dispatch_get_main_queue(), closure);
        }
        
        closure = nil;
        currTask = nil;
    };
    
    currTask = delayedBlock;
    
    [self delayExecutive:delayInSeconds cb:^{
        if (currTask)
        {
            currTask(NO);
        }
    }];
    
    return currTask;
}

+ (void)delayExecutive:(double)delayInSeconds cb:(void (^)(void))completionBlock
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), completionBlock);
}

+ (void)cancelDelayTask:(SUIDelayTask)currTask
{
    if (currTask)
    {
        currTask(YES);
    }
}


@end
