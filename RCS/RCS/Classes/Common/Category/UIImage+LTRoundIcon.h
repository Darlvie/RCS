//
//  UIImage+LTRoundIcon.h
//  RCS
//
//  Created by zyq on 15/10/22.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LTRoundIcon)


/**
*  @param iconName    传入的图片原图
*  @param borderImage 传入的边框图片原图（不需要则传nil）
*  @param border      边框大小
*  @param scale       缩放范围（不缩放传0）
*
*  @return 返回带图片边框的圆形图片
*/
+ (instancetype)imageWithIconName:(NSString *)iconName borderImage:(NSString *)borderImage border:(int)border scale:(CGFloat)scale;


/**
 *  @param iconName 传入的图片原图
 *  @param border   要绘制圆形图片的边框大小（不要边框传0）
 *  @param color    边框颜色
 *  @param scale    缩放范围 （不缩放传0）
 *
 *  @return 返回一个带颜色边框的圆形图片
 */
+ (instancetype)imageWithIconName:(NSString *)iconName border:(int)border borderColor:(UIColor *)color scale:(CGFloat)scale;

@end
