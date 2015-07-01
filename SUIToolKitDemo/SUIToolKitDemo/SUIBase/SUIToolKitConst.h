//
//  SUIToolKitConst.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/24.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#ifndef SUIToolKitDemo_SUIToolKitConst_h
#define SUIToolKitDemo_SUIToolKitConst_h



// _____________________________________________________________________________

#pragma mark - g

#define gClassName(__obj) [NSString stringWithUTF8String:object_getClassName(__obj)]

#define gRGB(__r,__g,__b) [UIColor colorWithRed:(__r)/255.0f green:(__g)/255.0f blue:(__b)/255.0f alpha:1.0f]
#define gRGBA(__r,__g,__b,__a) [UIColor colorWithRed:(__r)/255.0f green:(__g)/255.0f blue:(__b)/255.0f alpha:__a]

#define gLanguage [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] // @"zh-Hans", @"zh-Hant", @"en" ...



// _____________________________________________________________________________

#pragma mark - u

#define uWeakSelf typeof(self) __weak weakSelf = self;

#define uMainQueue(__stuff) \
dispatch_async(dispatch_get_main_queue(), ^{ \
__stuff \
});




// _____________________________________________________________________________

#pragma mark - Log

#define uXCODE_COLORS_ESCAPE    @"\033["
#define uXCODE_COLORS_RESET_FG  uXCODE_COLORS_ESCAPE  @"fg;"
#define uXCODE_COLORS_RESET_BG  uXCODE_COLORS_ESCAPE  @"bg;"
#define uXCODE_COLORS_RESET     uXCODE_COLORS_ESCAPE  @";"

#ifndef __OPTIMIZE__

#define NSLog(...)                  NSLog(__VA_ARGS__);
#define uFun                        NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d>" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__,                    __LINE__);
#define uLog(format, ...)           NSLog((uXCODE_COLORS_ESCAPE @"fg0,178,238;" @"%s <%d> " format uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__,  ##__VA_ARGS__);
#define uLogInfo(format, ...)       NSLog((uXCODE_COLORS_ESCAPE @"fg0,168,0;" @"%s <%d> " format uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__,    ##__VA_ARGS__);
#define uLogError(format, ...)      NSLog((uXCODE_COLORS_ESCAPE @"fg255,41,105;" @"%s <%d> " format uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define uRect(_rect)                NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #_rect, NSStringFromCGRect(_rect));
#define uPoint(_point)                NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #_point, NSStringFromCGPoint(_point));
#define uIndexPath(_indexPath)      NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d> %s %ld %ld" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #_indexPath, indexPath.section, indexPath.row);
#define uEdgeInsets(_edgeInsets)                NSLog((uXCODE_COLORS_ESCAPE @"fg89,89,207;" @"%s <%d> %s %@" uXCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, #_edgeInsets, NSStringFromUIEdgeInsets(_edgeInsets));

#else

#define NSLog(...) {}
#define uFun {}
#define uLog(format, ...) {}
#define uLogInfo(format, ...) {}
#define uLogError(format, ...) {}

#define uRect(_rect) {}
#define uPoint(_point) {}
#define uIndexPath(_indexPath) {}
#define uEdgeInsets(_edgeInsets) {}

#endif




// _____________________________________________________________________________

#pragma mark - Warc

#define uPerformSelectorLeakWarning(__stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
__stuff \
_Pragma("clang diagnostic pop") \
} while (0);



#endif