//
//  LTMessageModel.h
//  RCS
//
//  Created by zyq on 15/10/27.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LTMessageModelType) {
    LTMessageModelTypeMe = 0, //发送人是自己
    LTMessageModelTypeOther  //发送人是其他人
};

@interface LTMessageModel : NSObject

/** 消息内容 */
@property(nonatomic,copy) NSString *messageContentText;
/** 消息发送时间 */
@property(nonatomic,copy) NSString *messageTime;
/** 消息发送类型 */
@property(nonatomic,assign) LTMessageModelType messageType;
/** 是否隐藏发送时间 */
@property(nonatomic,assign) BOOL hideMessageTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)messageWithDic:(NSDictionary *)dict;
@end
