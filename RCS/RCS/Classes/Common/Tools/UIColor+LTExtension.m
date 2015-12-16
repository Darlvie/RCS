//
//  UIColor+LTExtension.m
//  RCS
//
//  Created by zyq on 15/10/23.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "UIColor+LTExtension.h"

@implementation UIColor (LTExtension)

//转换16进制颜色
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert alpha:(CGFloat)alpha {
    
    NSString *colorStr = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    
    if ([colorStr length] != 6) {
        return [UIColor blackColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *redStr = [colorStr substringWithRange:range];
    
    range.location = 2;
    NSString *greenStr = [colorStr substringWithRange:range];
    
    range.location = 4;
    NSString *blueStr = [colorStr substringWithRange:range];
    
    unsigned int r,g,b;
    
    [[NSScanner scannerWithString:redStr] scanHexInt:&r];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&g];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:alpha];
}
@end

