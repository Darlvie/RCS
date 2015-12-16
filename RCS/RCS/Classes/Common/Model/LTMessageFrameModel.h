//
//  LTMessageFrameModel.h
//  RCS
//
//  Created by zyq on 15/10/27.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class LTMessageModel;
@interface LTMessageFrameModel : NSObject
/** 数据模型 */
@property(nonatomic,strong) LTMessageModel *messageModel;

/** 消息发送时间的frame */
@property(nonatomic,assign,readonly) CGRect messageTimeF;
/** 消息正文的frame */
@property(nonatomic,assign,readonly) CGRect messageContentTextF;
/** 头像的frame */
@property(nonatomic,assign,readonly) CGRect avatarF;
/** cell高度 */
@property(nonatomic,assign,readonly) CGFloat cellHeight;
@end
