//
//  LTLinkVideoViewController.h
//  RCS
//
//  Created by zyq on 15/10/29.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTLinkVideoViewController : UIViewController
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/** 用户名 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 结束按钮 */
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
/** 转为语音通话按钮 */
@property (weak, nonatomic) IBOutlet UIButton *trunToVoiceCallButton;

@end
