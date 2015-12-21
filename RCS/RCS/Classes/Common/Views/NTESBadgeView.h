//
//  NTESBadgeView.h
//  RCS
//
//  Created by zyq on 15/12/18.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTESBadgeView : UIView

@property (nonatomic,copy) NSString *badgeValue;

+ (instancetype)viewWithBadgeTip:(NSString *)badgeValue;
@end
