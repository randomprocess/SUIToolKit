//
//  SUIMacros.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/11/25.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#ifndef SUIMacros_h
#define SUIMacros_h

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
#error SUIKitTool doesn't support Deployement Target version < 7.0
#endif

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  k
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - k

#define kIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define kAboveIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kAboveIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define kAboveIOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define kIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kProjectName [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenFrame [UIScreen mainScreen].bounds

// iOS7 @"zh-Hans", @"zh-Hant", ...
// iOS8 @"zh-Hans", @"zh-Hant", @"zh-HK", ...
// iOS9 @"zh-Hans-CN", @"zh-Hant-CN", @"zh-HK", @"zh-TW", ...
#define kLanguage [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]
#define kHans [kLanguage hasPrefix:@"zh-Hans"]
#define kHant ([kLanguage rangeOfString:@"^(zh-Hant|zh-HK|zh-TW).*$" options:NSRegularExpressionSearch].location != NSNotFound)
#define kHansOrHant (kHans || kHant)

#define kPathOfDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kURLOfDocument [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]

#define kPathOfTmp NSTemporaryDirectory()
#define kPathOfHome NSHomeDirectory()

#define kOpenRemoteNoti ((kAboveIOS8) ? [[UIApplication sharedApplication] isRegisteredForRemoteNotifications] : ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] ? YES : NO))

#define kNilOrNull(__ref) (((__ref) == nil) || ([(__ref) isEqual:[NSNull null]]))


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  g
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - g

#define gFormat(__format, ...) [NSString stringWithFormat:__format, ##__VA_ARGS__]
#define gFormatObj(__obj) [NSString stringWithFormat:@"%@", __obj]
#define gFormatInteger(__integer) [NSString stringWithFormat:@"%zd", __integer]
#define gFormatFloat(__float) [NSString stringWithFormat:@"%lf", __float]
#define gPredicate(__format, ...) [NSPredicate predicateWithFormat:__format, ##__VA_ARGS__]

#define gRGBA(__r,__g,__b,__a) [UIColor colorWithRed:(__r)/255.0f green:(__g)/255.0f blue:(__b)/255.0f alpha:__a]
#define gRGB(__r,__g,__b) gRGBA(__r, __g, __b, 1.0)
// Hex string that looks like @"#FF0000" or @"FF0000"
#define gHexA(__hex, __a) ({unsigned rgbValue = 0; \
NSString *hexString = [__hex stringByReplacingOccurrencesOfString:@"#" withString:@""]; \
[[NSScanner scannerWithString:hexString] scanHexInt:&rgbValue]; \
[UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:__a];})
#define gHex(__hex) gHexA(__hex, 1.0)
#define gRandomColo [UIColor colorWithRed:gRandomInRange(0, 255)/255.0f green:gRandomInRange(0, 255)/255.0f blue:gRandomInRange(0, 255)/255.0f alpha:1.0f]

#define gFont(__fontSize) [UIFont systemFontOfSize:__fontSize]
#define gBFont(__fontSize) [UIFont boldSystemFontOfSize:__fontSize]

#define gImageNamed(__name) [UIImage imageNamed:__name]
#define gImageResource(__name, __type) [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:__name ofType:__type]]]

#define gUserDefaults [NSUserDefaults standardUserDefaults]
#define gUserDefaultsBoolForKey(__key) [gUserDefaults boolForKey:__key]
#define gUserDefaultsObjForKey(__key) [gUserDefaults objectForKey:__key]
#define gUserDefaultsIntegerForKey(__key) [gUserDefaults integerForKey:__key]

#define gNotiCenter [NSNotificationCenter defaultCenter]
#define gNotiCenterPost(__notiName, __obj) [gNotiCenter postNotificationName:__notiName object:__obj]

#define gClassName(__obj) [NSString stringWithUTF8String:object_getClassName(__obj)]

#define gLocalString(__string) NSLocalizedString(__string, nil)
#define gLocalStringFromTable(__string, __fileName) NSLocalizedStringFromTable(__string, __fileName, nil)

#define gWindow ((UIWindow *)[[[UIApplication sharedApplication] windows] objectAtIndex:0])
#define gKeyWindow [UIApplication sharedApplication].keyWindow

#define gStoryboardNamed(__name) [UIStoryboard storyboardWithName:__name bundle:nil]
#define gStoryboardCurrentInstantiateWithStoryboardID(__storyboardID) [self.storyboard instantiateViewControllerWithIdentifier:__storyboardID]
#define gStoryboardInstantiate(__name, __storyboardID) [gStoryboardNamed(__name) instantiateViewControllerWithIdentifier:__storyboardID]
#define gStoryboardInitialViewController(__name) gStoryboardNamed(__name).instantiateInitialViewController


#define gRandomInRange(__startIndex, __endIndex) (int)(arc4random_uniform((u_int32_t)(__endIndex-__startIndex+1)) + __startIndex) // __startIndex ~ __endIndex

#define gAdapt(__length) round( kScreenWidth / 320.0 * __length )
#define gDegree(__para) __para*M_PI/180.0

#define gCurrDict(__obj) NSDictionary *currDict = (NSDictionary *)__obj;
#define gCurrAry(__Obj) NSArray *currAry = (NSArray *)__obj;

#define gIndexPath(__row, __section) [NSIndexPath indexPathForRow:__row inSection:__section]


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  u
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - u

#define uWeakSelf typeof(self) __weak weakSelf = self;
#define uStrongSelf typeof(weakSelf) __strong strongSelf = weakSelf;

#define uWeak(__obj) typeof(__obj) __weak weak_##__obj = __obj;
#define uBlock(__obj) typeof(__obj) __block block_##__obj = __obj;

//#define uTypeof(__TYPE, __PROPERTY) ({typeof(__TYPE *) __CLASS = __PROPERTY; __CLASS;})
#define uTypeof(__TYPE, __PROPERTY) ((__TYPE *)__PROPERTY)

#define uBorder(__view) __view.layer.borderColor=[gRandomColo CGColor];__view.layer.borderWidth=1;

#define uMainQueue(__stuff) \
if ([NSThread isMainThread]) { \
__stuff \
} else { \
dispatch_async(dispatch_get_main_queue(), ^{ \
__stuff \
}); \
}

#define uGlobalQueue(__stuff) { \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ \
__stuff \
}); \
}

#define uRepeat(__count, __stuff) \
for (NSInteger idx=0; idx < __count; idx ++) { \
__stuff \
}

#define uForIn(__ary, __declare, __stuff) \
for (NSInteger idx=0; idx<__ary.count; idx++) { \
__declare = __ary[idx]; \
__stuff \
}

#define uRegisterRemoteNoti {if (kAboveIOS8) { [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound categories:nil]]; [[UIApplication sharedApplication] registerForRemoteNotifications]; } else { [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound]; }}

#define uOnceToken(__stuff) \
{ \
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
__stuff \
});\
}

#define uSharedInstance \
+ (instancetype)sharedInstance { \
static id sharedSingleton = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedSingleton = [[self alloc] init]; \
}); \
return sharedSingleton; \
}

#define uSharedInstanceWithCommonInit \
+ (instancetype)sharedInstance { \
static id sharedSingleton = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedSingleton = [[self alloc] init]; \
[sharedSingleton commonInit]; \
}); \
return sharedSingleton; \
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Log
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Log

#define uXCODE_COLORS_ESCAPE        @"\033["
#define uXCODE_COLORS_RESET_FG      uXCODE_COLORS_ESCAPE  @"fg;"
#define uXCODE_COLORS_RESET_BG      uXCODE_COLORS_ESCAPE  @"bg;"
#define uXCODE_COLORS_RESET         uXCODE_COLORS_ESCAPE  @";"

#ifndef __OPTIMIZE__

#define NSLog(...)                  NSLog(__VA_ARGS__);
#define uFun                        NSLog((uXCODE_COLORS_ESCAPE @"fg217,56,41;" @"\n%s <%d>" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__);
#define uLog(__format, ...)         NSLog((uXCODE_COLORS_ESCAPE @"fg0,178,238;" @"\n%s\n<%d> " __format uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define uLogInfo(__format, ...)     NSLog((uXCODE_COLORS_ESCAPE @"fg0,168,0;" @"\n-> " __format uXCODE_COLORS_RESET), ##__VA_ARGS__);
#define uLogError(__format, ...)    NSLog((uXCODE_COLORS_ESCAPE @"fg255,41,105;" @"\n## " __format uXCODE_COLORS_RESET), ##__VA_ARGS__);
#define uAssert(__condition, __desc, ...) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wformat-extra-args\"") \
if (!(__condition)) \
uLogError(__desc, ##__VA_ARGS__); \
_Pragma("clang diagnostic pop") \
} while (0);

#define uInteger(__integer)         NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"\n%s\n<%d> %s ⤭ %zd ⤪[;" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__integer, __integer)
#define uFloat(__float)             NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"\n%s\n<%d> %s ⤭ %lf ⤪[;" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__float, __float)
#define uObj(__obj)                 NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"\n%s\n<%d> %s ⤭ %@ ⤪[;" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__obj, __obj)
#define uRect(__rect)               NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"\n%s\n<%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__rect, NSStringFromCGRect(__rect))
#define uSize(__size)               NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"\n%s\n<%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__size, NSStringFromCGSize(__size))
#define uPoint(__point)             NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"\n%s\n<%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__point, NSStringFromCGPoint(__point))
#define uIndexPath(__indexPath)     NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"\n%s\n<%d> %s %zd %zd" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__indexPath, __indexPath.section, __indexPath.row)
#define uEdgeInsets(__edgeInsets)   NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"\n%s\n<%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #__edgeInsets, NSStringFromUIEdgeInsets(__edgeInsets))

#else

#define NSLog(...) {}
#define uFun {}
#define uLog(__format, ...) {}
#define uLogInfo(__format, ...) {}
#define uLogError(__format, ...) {}
#define uAssert(__condition, __format, ...) {}

#define uInteger(__integer) {}
#define uFloat(__float) {}
#define uObj(__obj) {}
#define uRect(__rect) {}
#define uSize(__size) {}
#define uPoint(__point) {}
#define uIndexPath(__indexPath) {}
#define uEdgeInsets(__edgeInsets) {}

#endif


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Warc
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Warc

#define uWarc

#if __clang__
#define __PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH(__warc) \
do { \
_Pragma("clang diagnostic push") \
_Pragma(__warc)
#define __PRAGMA_NO_EXTRA_ARG_WARNINGS_POP \
_Pragma("clang diagnostic pop") \
} while (0);
#else
#define __PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH
#define __PRAGMA_NO_EXTRA_ARG_WARNINGS_POP
#endif


#define uWarcPerformSelector(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

#define uWarcUnreachable(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Wunreachable\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

#define uWarcUnused(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Wunused\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

#define uWarcDeprecated(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Wdeprecated\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

#endif
