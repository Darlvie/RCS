//
//  LTRegisterManager.m
//  RCS
//
//  Created by zyq on 15/12/17.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTRegisterManager.h"
#import "AFNetworking.h"
#import "NSDictionary+NTESJson.h"

@implementation LTRegisterData


@end

@implementation LTRegisterManager

+ (instancetype)sharedManager {
    static LTRegisterManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTRegisterManager alloc] init];
    });
    return instance;
}

- (void)registerUser:(LTRegisterData *)data completion:(LTRegisterHandler)completion {
    NSString *apiURL = @"https://app.netease.im/api";
    NSString *URLString = [apiURL stringByAppendingString:@"/createDemoUser"];
    NSURL *url = [NSURL URLWithString:URLString];
    // NSURLRequestUseProtocolCachePolicy默认的缓存策略，
    // 如果缓存不存在，直接从服务端获取。如果缓存存在，会根据response中的Cache-Control字段判断下一步操作
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30];
    [request setHTTPMethod:@"Post"];
    [request addValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"nim_demo_ios" forHTTPHeaderField:@"User-Agent"];
    [request addValue:@"2663bf1d5cea0701a6e9375a2cc571aa" forHTTPHeaderField:@"appkey"];
    
    NSString *postData = [NSString stringWithFormat:@"username=%@&nickname=%@&password=%@",data.username,data.nickname,data.token];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger statusCode = operation.response.statusCode;
        NSError *error = [NSError errorWithDomain:@"ntes domain"
                                             code:statusCode
                                         userInfo:nil];
        NSString *errorMsg;
        if (statusCode == 200 && [responseObject isKindOfClass:[NSData class]]) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:0
                                                                   error:nil];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSInteger res = [dict jsonInteger:@"res"];
                if (res == 200) {
                    error = nil;
                } else {
                    error = [NSError errorWithDomain:@"ntes domain"
                                                code:res
                                            userInfo:nil];
                    DebugLogInfo(@"register response %@",dict);
                    errorMsg = dict[@"errmsg"];
                }
            }
            
            if (completion) {
                completion(error,errorMsg);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error,nil);
        }
    }];
    
    [operation start];
}














@end
