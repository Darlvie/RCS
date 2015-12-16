//
//  UIImage+LTRoundIcon.m
//  RCS
//
//  Created by zyq on 15/10/22.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "UIImage+LTRoundIcon.h"

@implementation UIImage (LTRoundIcon)

//绘制带图片边框的圆形图片
+ (instancetype)imageWithIconName:(NSString *)iconName borderImage:(NSString *)borderImage border:(int)border scale:(CGFloat)scale {
    
    //头像图片
    UIImage *avatarImg = [UIImage imageNamed:iconName];
    
    //边框图片    
    UIImage *borderImg = [UIImage imageNamed:borderImage];
    
    CGSize size = CGSizeMake(avatarImg.size.width + border, avatarImg.size.height + border);
    
    //创建图片上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    //绘制边框的圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    
    CGContextFillPath(context);
    
    //绘制边框图片
    [borderImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 设置头像frame
    CGFloat iconX = border / 2;
    CGFloat iconY = border / 2;
    CGFloat iconW = avatarImg.size.width;
    CGFloat iconH = avatarImg.size.height;
    
    //绘制圆形图片上下文
    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制头像
    [avatarImg drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    //取出整个图片上下文的图片
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return iconImage;
}

//绘制带颜色边框的圆形图片
+ (instancetype)imageWithIconName:(NSString *)iconName border:(int)border borderColor:(UIColor *)color scale:(CGFloat)scale {
    //头像图片
    UIImage *avatarImg = [UIImage imageNamed:iconName];
    
    CGSize size = CGSizeMake(avatarImg.size.width + border, avatarImg.size.height + border);
    
    //创建图片上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    //绘制边框的圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    
    [color set];
    
    CGContextFillPath(context);
    
    //设置头像frame
    CGFloat iconX = border / 2;
    CGFloat iconY = border / 2;
    CGFloat iconW = avatarImg.size.width;
    CGFloat iconH = avatarImg.size.height;
    
    //绘制圆形图片范围
    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制头像
    [avatarImg drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    //取出整个图片上下文的图片
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return iconImage;

}
@end
