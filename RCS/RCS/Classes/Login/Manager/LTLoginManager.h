//
//  LTLoginManager.h
//  RCS
//
//  Created by zyq on 15/12/17.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LTLoginData : NSObject
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *token;
@end

@interface LTLoginManager : NSObject

+ (instancetype)sdkManager;
+ (instancetype)appManager;

@property (nonatomic,strong) LTLoginData *currentLoginData;
@end
