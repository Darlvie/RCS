//
//  LTImageCache.h
//  RCS
//
//  Created by zyq on 15/11/9.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LastCacheKitStatus) {
    LastCacheKitStatusNotFound,
    LastCacheKitStatusInMemory,
    LastCacheKitStatusInDisk
};

@interface LTImageCache : NSObject
@property (nonatomic, assign) NSInteger maxMemoryCacheNumber;
@property (nonatomic, assign) LastCacheKitStatus lastCacheKitStatus;
@property (nonatomic, retain) NSString * cachePath;


- (id) initWithCachePath:(NSString*)path andMaxMemoryCacheNumber:(NSInteger)maxNumber;

- (void) putImage:(NSData *) imageData withName:(NSString*)imageName ;
- (NSData *) getImage:(NSString *)imageName;
- (void)clear;

+ (NSString *)parseUrlForCacheName:(NSString *)name;

@end
