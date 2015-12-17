//
//  LTContactModel.h
//  RCS
//
//  Created by zyq on 15/10/28.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTContactModel : NSObject

@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *avatarUrl;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)contactWithDic:(NSDictionary *)dic;
@end
