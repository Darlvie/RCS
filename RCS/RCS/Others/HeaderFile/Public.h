//
//  Public.h
//  RCS
//
//  Created by zyq on 15/10/26.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//



#ifndef RCS_Public_h
#define RCS_Public_h

//#import <CocoaLumberjack/CocoaLumberjack.h>
//
//#ifdef DEBUG
//static const int ddLogLevel = DDLogLevelVerbose;
//#else
//static const int ddLogLevel = DDLogLevelOff;
//#endif

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#ifdef DEBUG
#define DebugLog(...)               NSLog(__VA_ARGS__)
#define DebugMethod()               NSLog(@"%s", __func__)
#define DebugLogError(frmt, ...)    NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define DebugLogWarning(frmt, ...)  NSLog((XCODE_COLORS_ESCAPE @"fg255,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define DebugLogInfo(frmt, ...)     NSLog((XCODE_COLORS_ESCAPE @"fg0,118,245;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#else
#define DebugLog(...)
#define DebugMethod()
#define DebugLogError(frmt, ...)
#define DebugLogWarning(frmt, ...)
#define DebugLogInfo(frmt, ...)
#endif


//获取RGBA颜色
#define RGBA(r, g, b, a)                   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                       RGBA(r, g, b, 1.0f)
#define UIColorFromHexValue(hexValue)      [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#pragma mark - UIColor宏定义
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

// 屏幕大小尺寸
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGTH   [UIScreen mainScreen].bounds.size.height

//常用尺寸
#define NORMAL_HEIGHT   44
#define AVATAR_WIDTH    50
#define AVATAR_HEIGHT   50
#define BUTTON_FONET    [UIFont systemFontOfSize:15.0f]

//系统版本
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

#define USERDEFAULT     [NSUserDefaults standardUserDefaults]

#define Message_Font_Size   14      // 文字大小


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif
