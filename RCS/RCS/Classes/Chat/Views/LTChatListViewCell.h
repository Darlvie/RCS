//
//  LTChatListViewCell.h
//  RCS
//
//  Created by zyq on 15/10/23.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTChatListViewCell : UITableViewCell
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/** 用户昵称 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 会话内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 时间戳 */
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end
