//
//  LTLoginManager.m
//  RCS
//
//  Created by zyq on 15/12/17.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTLoginManager.h"
#import "NTESFileLocationHelper.h"

#define LTUsername      @"username"
#define LTToken        @"token"

@interface LTLoginData ()<NSCoding>

@end
@implementation LTLoginData

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _username = [aDecoder decodeObjectForKey:LTUsername];
        _token = [aDecoder decodeObjectForKey:LTToken];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if ([_username length]) {
        [aCoder encodeObject:_username forKey:LTUsername];
    }
    if ([_token length]) {
        [aCoder encodeObject:_token forKey:LTToken];
    }
}

@end

@interface LTLoginManager ()
@property (nonatomic,copy) NSString *filePath;
@end
@implementation LTLoginManager

+ (instancetype)sdkManager {
    static LTLoginManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:@"nim_sdk_login_data"];
        instance = [[LTLoginManager alloc] initWithPath:filePath];
    });
    return instance;
}

+ (instancetype)appManager {
    static LTLoginManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:@"nim_app_login_data"];
        instance = [[LTLoginManager alloc] initWithPath:filePath];
    });
    return instance;
}

- (instancetype)initWithPath:(NSString *)filePath {
    if (self = [super init]) {
        _filePath = filePath;
        [self readData];
    }
    return self;
}

- (void)readData {
    NSString *filePath = [self filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _currentLoginData = [object isKindOfClass:[LTLoginData class]] ? object : nil;
    }
}

- (void)setCurrentLoginData:(LTLoginData *)currentLoginData {
    _currentLoginData = currentLoginData;
    [self saveData];
}

- (void)saveData {
    NSData *data = [NSData data];
    if (_currentLoginData) {
        data = [NSKeyedArchiver archivedDataWithRootObject:_currentLoginData];
    }
    [data writeToFile:[self filePath] atomically:YES];
}






@end
