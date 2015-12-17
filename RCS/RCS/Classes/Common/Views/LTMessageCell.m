//
//  LTMessageCell.m
//  RCS
//
//  Created by zyq on 15/10/27.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTMessageCell.h"
#import "LTMessageFrameModel.h"
#import "LTMessageModel.h"

@interface LTMessageCell ()
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIButton *messageContentView;
@property(nonatomic,strong) UIImageView *avatarView;
@end
@implementation LTMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)messageCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"messageCell";
    LTMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LTMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //时间标签
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:13.f];
        _timeLabel.textColor = UIColorFromHexValue(0xa3a3a3);
        [self.contentView addSubview:_timeLabel];
        
        //正文显示容器
        _messageContentView = [[UIButton alloc]init];
        _messageContentView.titleLabel.font = BUTTON_FONET;
        _messageContentView.titleLabel.numberOfLines = 0;
        _messageContentView.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        [_messageContentView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_messageContentView];
        
        //头像
        _avatarView = [[UIImageView alloc]init];
        [self.contentView addSubview:_avatarView];
    }
    return self;
}

/**
 *  设置内容和frame
 */
- (void)setMessageFrame:(LTMessageFrameModel *)messageFrame {
    _messageFrame = messageFrame;
    
    LTMessageModel *messageModel = messageFrame.messageModel;
    
    //时间
    _timeLabel.frame = messageFrame.messageTimeF;
    _timeLabel.text = messageModel.messageTime;
    
    //头像
    _avatarView.frame = messageFrame.avatarF;
    if (messageModel.messageType == LTMessageModelTypeMe) {
        _avatarView.image = [UIImage imageNamed:@"avatar02.jpeg"];
    } else {
        _avatarView.image = [UIImage imageNamed:@"avatar03"];
    }
    
    //正文
    _messageContentView.frame = messageFrame.messageContentTextF;
    [_messageContentView setTitle:messageModel.messageContentText forState:UIControlStateNormal];
    
    if (messageModel.messageType == LTMessageModelTypeMe) {
        [_messageContentView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_messageContentView setBackgroundImage:[UIImage imageNamed:@"chat_send_nor"] forState:UIControlStateNormal];
    } else {
         [_messageContentView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_messageContentView setBackgroundImage:[UIImage imageNamed:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
    
}

@end
