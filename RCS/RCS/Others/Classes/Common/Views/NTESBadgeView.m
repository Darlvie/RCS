//
//  NTESBadgeView.m
//  RCS
//
//  Created by zyq on 15/12/18.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "NTESBadgeView.h"
#import "NSString+NTES.h"

@interface NTESBadgeView ()

@property (nonatomic,strong) UIColor *badgeBackgroundColor;
@property (nonatomic,strong) UIColor *badgeTextColor;
@property (nonatomic,assign) UIFont *badgeTextFont;
@property (nonatomic,assign) CGFloat badgeTopPadding;//数字顶部到红圈的距离
@property (nonatomic,assign) CGFloat badgeLeftPadding;//数字左部到红圈的距离
@property (nonatomic,assign) CGFloat whiteCircleWidth;//最外层白圈的宽度
@end

@implementation NTESBadgeView

+ (instancetype)viewWithBadgeTip:(NSString *)badgeValue {
    if (!badgeValue) {
        badgeValue = @"";
    }
    
    NTESBadgeView *instance = [[NTESBadgeView alloc] init];
    instance.frame = [instance frameWithStr:badgeValue];
    instance.badgeValue = badgeValue;
    
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor  = [UIColor clearColor];
        _badgeBackgroundColor = [UIColor redColor];
        _badgeTextColor       = [UIColor whiteColor];
         _badgeTextFont       = [UIFont boldSystemFontOfSize:12];
        _whiteCircleWidth     = 2.f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if ([[self badgeValue] length]) {
        [self drawWithContent:rect context:context];
    } else {
        [self drawWithOutContent:rect context:context];
    }
    CGContextRestoreGState(context);
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    if (_badgeValue.integerValue > 9) {
        _badgeLeftPadding = 6.f;
    } else {
        _badgeLeftPadding = 2.f;
    }
    _badgeTopPadding = 2.f;
    
    self.frame = [self frameWithStr:badgeValue];
    
    [self setNeedsDisplay];
}

- (CGSize)badgeSizeWithStr:(NSString *)badgeValue {
    if (!badgeValue|| badgeValue.length == 0) {
        return CGSizeZero;
    }
    
    CGSize size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:self.badgeTextFont}];
    if (size.width < size.height) {
        size = CGSizeMake(size.height, size.height);
    }
    return size;
}

- (CGRect)frameWithStr:(NSString *)badgeValue {
    CGSize badgeSize = [self badgeSizeWithStr:badgeValue];
    CGRect badgeFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, badgeSize.width + self.badgeLeftPadding * 2 + self.whiteCircleWidth * 2, badgeSize.height + self.badgeTopPadding * 2 + self.whiteCircleWidth * 2);
    return badgeFrame;
}

#pragma mark - Private
- (void)drawWithContent:(CGRect)rect context:(CGContextRef)context {
    CGRect bodyFrame = self.bounds;
    CGRect bkgFrame = CGRectInset(self.bounds, self.whiteCircleWidth, self.whiteCircleWidth);
    CGRect badgeSize = CGRectInset(self.bounds, self.whiteCircleWidth + self.badgeLeftPadding, self.whiteCircleWidth + self.badgeTopPadding);
    
    if ([self badgeBackgroundColor]) { //外白色描边
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        if ([self badgeValue].integerValue > 9) {
            CGFloat circleWidth = bodyFrame.size.height;
            CGFloat totalWidth = bodyFrame.size.width;
            CGFloat diffWidth = totalWidth - circleWidth;
            CGPoint originPoint = bodyFrame.origin;
            CGRect leftCircleFrame = CGRectMake(originPoint.x, originPoint.y, circleWidth, circleWidth);
            CGRect centerFrame = CGRectMake(originPoint.x + circleWidth/2, originPoint.y, diffWidth, circleWidth);
            CGRect rightCircleFrame = CGRectMake(originPoint.x + diffWidth , originPoint.y, circleWidth, circleWidth);
            CGContextFillEllipseInRect(context, leftCircleFrame);
            CGContextFillRect(context, centerFrame);
            CGContextFillRect(context, rightCircleFrame);
        } else {
            CGContextFillEllipseInRect(context, bodyFrame);
        }
        
        //badge背景色
        CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);
        if ([self badgeValue].integerValue > 9) {
            CGFloat circleWidth = bkgFrame.size.height;
            CGFloat totalWidth = bkgFrame.size.width;
            CGFloat diffWidth = totalWidth - circleWidth;
            CGPoint originPoint = bkgFrame.origin;
            CGRect leftCircleFrame = CGRectMake(originPoint.x, originPoint.y, circleWidth, circleWidth);
            CGRect centerFrame = CGRectMake(originPoint.x + circleWidth/2, originPoint.y, diffWidth, circleWidth);
            CGRect rightCircleFrame = CGRectMake(originPoint.x + diffWidth, originPoint.y, circleWidth, circleWidth);
            CGContextFillEllipseInRect(context, leftCircleFrame);
            CGContextFillRect(context, centerFrame);
            CGContextFillRect(context, rightCircleFrame);
        } else {
            CGContextFillEllipseInRect(context, bkgFrame);
        }
    }
    CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);
    NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [badgeTextStyle setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *badgeTextAttributes = @{
                                          NSFontAttributeName:[self badgeTextFont],
                                          NSForegroundColorAttributeName:[self badgeTextColor],
                                          NSParagraphStyleAttributeName:badgeTextStyle
                                          };
    [[self badgeValue] drawInRect:CGRectMake(self.whiteCircleWidth + self.badgeLeftPadding,
                                             self.whiteCircleWidth + self.badgeTopPadding,
                                             badgeSize.size.width, badgeSize.size.height)
                   withAttributes:badgeTextAttributes];
    
}


- (void)drawWithOutContent:(CGRect)rect context:(CGContextRef)context {
    CGRect bodyFrame = self.bounds;
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillEllipseInRect(context, bodyFrame);
}







@end
