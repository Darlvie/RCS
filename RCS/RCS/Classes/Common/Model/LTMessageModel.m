//
//  LTMessageModel.m
//  RCS
//
//  Created by zyq on 15/10/27.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTMessageModel.h"

@implementation LTMessageModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)messageWithDic:(NSDictionary *)dict {
    return [[self alloc]initWithDict:dict];
}
@end
