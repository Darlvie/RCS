//
//  Public.h
//  RCS
//
//  Created by zyq on 15/10/26.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#ifndef RCS_Public_h
#define RCS_Public_h

//定义log
#ifdef DEBUG
#define LTLog(...) NSLog(__VA_ARGS__)
#else
#define LTLog(...)
#endif

//获取RGBA颜色
#define RGBA(r, g, b, a)                   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                       RGBA(r, g, b, 1.0f)
#define UIColorFromHexValue(hexValue)      [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]


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

#endif
