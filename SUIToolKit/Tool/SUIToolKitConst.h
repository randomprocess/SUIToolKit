//
//  SUIToolKitConst.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/24.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#ifndef SUIToolKitDemo_SUIToolKitConst_h
#define SUIToolKitDemo_SUIToolKitConst_h


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
#error SUIKitTool doesn't support Deployement Target version < 7.0
#endif


// _____________________________________________________________________________

#pragma mark - k

#define kAboveIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kAboveIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define kPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#define kLanguage [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] // @"zh-Hans", @"zh-Hant", @"en" ...
#define kProjectName [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]

#define kDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kDocumentURL [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]

#define kOpenRemoteNoti ((kAboveIOS8) ? [[UIApplication sharedApplication] isRegisteredForRemoteNotifications] : ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] ? YES : NO))


// _____________________________________________________________________________

#pragma mark - g


#define gFormat(__format, ...) [NSString stringWithFormat:__format, ##__VA_ARGS__]

#define gRGB(__r,__g,__b) [UIColor colorWithRed:(__r)/255.0f green:(__g)/255.0f blue:(__b)/255.0f alpha:1.0f]
#define gRGBA(__r,__g,__b,__a) [UIColor colorWithRed:(__r)/255.0f green:(__g)/255.0f blue:(__b)/255.0f alpha:__a]

#define gFont(__fontSize) [UIFont systemFontOfSize:__fontSize]
#define gBFont(__fontSize) [UIFont boldSystemFontOfSize:__fontSize]

#define gImageNamed(__name) [UIImage imageNamed:__name]
#define gClassName(__obj) [NSString stringWithUTF8String:object_getClassName(__obj)]

#define gWindow ((UIWindow *)[[[UIApplication sharedApplication] windows] objectAtIndex:0])

#define gUserDefaults [NSUserDefaults standardUserDefaults]
#define gUserDefaultsBoolForKey(__key) [[NSUserDefaults standardUserDefaults] boolForKey:__key]
#define gUserDefaultsObjForKey(__key) [[NSUserDefaults standardUserDefaults] objectForKey:__key]
#define gUserDefaultsIntegerForKey(__key) [[NSUserDefaults standardUserDefaults] integerForKey:__key]

#define gNotificationCenter [NSNotificationCenter defaultCenter]

#define gMainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define gViewControllerInstantiate(__storyboardId) [gMainStoryboard instantiateViewControllerWithIdentifier:__storyboardId]

#define gRandomInRange(__startIndex, __endIndex) (int)(arc4random_uniform(__endIndex-__startIndex) + __startIndex) // __startIndex ~ (__endIndex - 1)
#define gRandomColo [UIColor colorWithRed:gRandomInRange(0, 256)/255.0f green:gRandomInRange(0, 256)/255.0f blue:gRandomInRange(0, 256)/255.0f alpha:1.0f]


// _____________________________________________________________________________

#pragma mark - u

#define uWeakSelf typeof(self) __weak weakSelf = self;
#define uStrongSelf typeof(weakSelf) __strong strongSelf = weakSelf;

#define uMainQueue(__stuff) \
if ([NSThread isMainThread]) { \
__stuff \
} else { \
dispatch_async(dispatch_get_main_queue(), ^{ \
__stuff \
}); \
} \


// _____________________________________________________________________________

#pragma mark - Log

#define uXCODE_COLORS_ESCAPE        @"\033["
#define uXCODE_COLORS_RESET_FG      uXCODE_COLORS_ESCAPE  @"fg;"
#define uXCODE_COLORS_RESET_BG      uXCODE_COLORS_ESCAPE  @"bg;"
#define uXCODE_COLORS_RESET         uXCODE_COLORS_ESCAPE  @";"

#ifndef __OPTIMIZE__

#define NSLog(...)                  NSLog(__VA_ARGS__);
#define uFun                        NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d>" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__,                    __LINE__);
#define uLog(__format, ...)           NSLog((uXCODE_COLORS_ESCAPE @"fg0,178,238;" @"%s <%d>\n-> " __format uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__,  ##__VA_ARGS__);
#define uLogInfo(__format, ...)       NSLog((uXCODE_COLORS_ESCAPE @"fg0,168,0;" @"%s <%d>\n-> " __format uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__,    ##__VA_ARGS__);
#define uLogError(__format, ...)      NSLog((uXCODE_COLORS_ESCAPE @"fg255,41,105;" @"#### %s <%d>\n-> " __format uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define uRect(__rect)                NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__rect, NSStringFromCGRect(__rect));
#define uPoint(__point)              NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__point, NSStringFromCGPoint(__point));
#define uIndexPath(__indexPath)      NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d> %s %ld %ld" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__indexPath, __indexPath.section, __indexPath.row);
#define uEdgeInsets(__edgeInsets)    NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__edgeInsets, NSStringFromUIEdgeInsets(__edgeInsets));

#else

#define NSLog(...) {}
#define uFun {}
#define uLog(__format, ...) {}
#define uLogInfo(__format, ...) {}
#define uLogError(__format, ...) {}

#define uRect(__rect) {}
#define uPoint(__point) {}
#define uIndexPath(__indexPath) {}
#define uEdgeInsets(__edgeInsets) {}

#endif




// _____________________________________________________________________________

#pragma mark - Warc

#define uWarcPerformSelector(__stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
__stuff \
_Pragma("clang diagnostic pop") \
} while (0);


#define uWarcWunreachable(__stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wunreachable-code\"") \
__stuff \
_Pragma("clang diagnostic pop") \
} while (0);


#define uWarcWunusedGetter(__stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wunused-getter-return-value\"") \
__stuff \
_Pragma("clang diagnostic pop") \
} while (0);


#endif
