//
//  UIColor+LTExtension.h
//  RCS
//
//  Created by zyq on 15/10/23.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LTExtension)

/**
 *  将传入的16进制颜色转换成RGB颜色
 *
 *  @param stringToConvert 16进制颜色字符串
 *
 *  @return RGB颜色UIColor
 */
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert alpha:(CGFloat)alpha;
@end
