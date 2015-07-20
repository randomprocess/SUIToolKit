//
//  SUITool.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/20.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUITool.h"
#import "SUIToolKitConst.h"

NSString *const SUIEver_Launched = @"Ever_Launched";
NSString *const SUICurr_Version = @"Curr_Version";


// _____________________________________________________________________________

@interface SUITool ()

@property (nonatomic,assign,getter=isFirstLaunched) BOOL firstLaunched;
@property (nonatomic,copy) NSString *everVersion;

@property (nonatomic,assign,getter=isKeyboardShow) BOOL keyboardShow;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) double keyboardAnimationDuration;


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
            uLogInfo(@"ever launched non-update-version CurrVersion > %@ <", currVersion);
        }
        else
        {
            [gUserDefaults setObject:currVersion forKey:SUICurr_Version];
            [gUserDefaults synchronize];
            
            self.firstLaunched = YES;
            uLogInfo(@"ever launched update-version EverVersion > %@ <  CurrVersion > %@ <", self.everVersion, currVersion);
        }
    }
    else
    {
        [gUserDefaults setBool:YES forKey:SUIEver_Launched];
        [gUserDefaults setObject:kVersion forKey:SUICurr_Version];
        [gUserDefaults synchronize];
        
        self.firstLaunched = YES;
        uLogInfo(@"first launched CurrVersion > %@ <", kVersion);
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


#pragma mark - File

+ (BOOL)fileCreateDirectory:(NSString *)filePath
{
    if ([self fileExist:filePath])
    {
        NSError *anyError = nil;
        BOOL ret = [[NSFileManager defaultManager]
                    createDirectoryAtPath:filePath
                    withIntermediateDirectories:YES
                    attributes:nil
                    error:&anyError];
        if (ret) {
            uLogInfo(@"file create director succeed At > %@ <", filePath);
        } else {
            uLogError(@"file create director Error > %@ <    At > %@ <", anyError, filePath);
        }
        return ret;
    }
    return YES;
}

+ (BOOL)fileExist:(NSString *)filePath
{
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (ret) {
        uLogInfo(@"file exist At > %@ <", filePath);
    } else {
        uLogInfo(@"file not exist At > %@ <", filePath);
    }
    return ret;
}

+ (BOOL)fileWrite:(NSData *)data atPath:(NSString *)filePath
{
    NSError *anyError = nil;
    BOOL ret = [data writeToFile:filePath
                         options:NSDataWritingAtomic
                           error:&anyError];
    if (ret) {
        uLogInfo(@"file write succeed At > %@ <", filePath);
    } else {
        uLogError(@"file write Error > %@ <  At > %@ <", anyError, filePath);
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
        uLogInfo(@"file read succeed Length > %zd <  At > %@ <", readData.length, filePath);
    } else {
        uLogError(@"file read Error > %@ <  At > %@ <", anyError, filePath);
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
            uLogInfo(@"file size succeed Size > %zd < At > %@ <", fSize, filePath);
            return fSize;
        } else {
            uLogError(@"file size Error > %@ <  At > %@ <", anyError, filePath);
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
            uLogInfo(@"file delete succeed At > %@ <", filePath);
        } else {
            uLogError(@"file delete Error > %@ <  At > %@ <", anyError, filePath);
        }
        return ret;
    }
    return YES;
}



#pragma mark - Camera

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


@end
