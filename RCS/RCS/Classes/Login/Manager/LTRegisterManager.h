//
//  LTRegisterManager.h
//  RCS
//
//  Created by zyq on 15/12/17.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LTRegisterData : NSObject

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *nickname;
@end


typedef void(^LTRegisterHandler)(NSError *error,NSString *errorMsg);
@interface LTRegisterManager : NSObject

+ (instancetype)sharedManager;
- (void)registerUser:(LTRegisterData *)data
          completion:(LTRegisterHandler)completion;
@end
