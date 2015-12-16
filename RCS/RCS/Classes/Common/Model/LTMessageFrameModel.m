//
//  LTMessageFrameModel.m
//  RCS
//
//  Created by zyq on 15/10/27.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTMessageFrameModel.h"
#import "LTMessageModel.h"

@implementation LTMessageFrameModel

- (void)setMessageModel:(LTMessageModel *)messageModel {
    _messageModel = messageModel;
    
    CGFloat padding = 10;
    
    //消息发送时间
    if (messageModel.hideMessageTime == NO) {
        _messageTimeF = CGRectMake(0, 0, SCREEN_WIDTH, NORMAL_HEIGHT);
    }
    
    //头像
    CGFloat avatarX;
    CGFloat avatarY = CGRectGetMaxY(_messageTimeF);
    CGFloat avatarW = AVATAR_WIDTH;
    CGFloat avatarH = AVATAR_HEIGHT;
    if (messageModel.messageType == LTMessageModelTypeMe) { //是自己发的
        avatarX = SCREEN_WIDTH - avatarW - padding;
    } else { //别人发的
        avatarX = padding;
    }
    _avatarF = CGRectMake(avatarX, avatarY, avatarW, avatarH);
    
    //消息正文
    CGFloat contentTextX;
    CGFloat contentTextY = avatarY + padding;
    
    CGSize textMaxSize = CGSizeMake(150, MAXFLOAT);
    CGSize textRealSize = [messageModel.messageContentText boundingRectWithSize:textMaxSize
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName:BUTTON_FONET}
                                                                        context:nil].size;
    CGSize textButtonSize = CGSizeMake(textRealSize.width + 40, textRealSize.height + 40);
    
    if (messageModel.messageType == LTMessageModelTypeMe) {
        contentTextX = SCREEN_WIDTH - avatarW - padding*2 - textButtonSize.width;
    } else {
        contentTextX = padding*2 + avatarW;
    }
    _messageContentTextF = (CGRect){{contentTextX,contentTextY},textButtonSize};
    
    //cell高度
    _cellHeight = MAX(CGRectGetMaxY(_avatarF), CGRectGetMaxY(_messageContentTextF));
}

@end
