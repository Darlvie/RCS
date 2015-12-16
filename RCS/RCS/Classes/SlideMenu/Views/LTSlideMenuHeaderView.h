//
//  LTSlideMenuHeaderView.h
//  RCS
//
//  Created by zyq on 15/10/23.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSlideMenuHeaderView : UIView
/** 设置头像 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/** 设置用户名 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 菜单编辑按钮 */
@property (weak, nonatomic) IBOutlet UIButton *menuEditButton;

+ (instancetype)headerView;
@end
