//
//  LTContactModel.m
//  RCS
//
//  Created by zyq on 15/10/28.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTContactModel.h"

@implementation LTContactModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)contactWithDic:(NSDictionary *)dic {
    return [[LTContactModel alloc]initWithDic:dic];
}
@end
