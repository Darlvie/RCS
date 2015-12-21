//
//  LTSlideMenuHeaderView.m
//  RCS
//
//  Created by zyq on 15/10/23.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTSlideMenuHeaderView.h"

@implementation LTSlideMenuHeaderView

+ (instancetype)headerView {
    NSBundle *headerViewBundle = [NSBundle mainBundle];
    LTSlideMenuHeaderView *headerView = [[headerViewBundle loadNibNamed:@"LTSlideMenuHeaderView" owner:nil options:nil] lastObject];
    return headerView;
}

@end
