//
//  LTImageCache.m
//  RCS
//
//  Created by zyq on 15/11/9.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTImageCache.h"

@interface LTImageCache()

@property (nonatomic, retain) NSFileManager * fileManager;
@property (nonatomic, retain) NSMutableDictionary * memoryCache;
@property (nonatomic, retain) NSMutableArray *memoryCacheKeys;

@end

#define PATH_OF_TEMP        [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]

@implementation LTImageCache;

static BOOL debugMode = NO;

#pragma mark - 初始化
- (id) init {
    return [self initWithCachePath:@"LTImageCache" andMaxMemoryCacheNumber:50];
}

- (id) initWithCachePath:(NSString*)path andMaxMemoryCacheNumber:(NSInteger)maxNumber {
    NSString * tmpDir = PATH_OF_TEMP;
    if ([path hasPrefix:tmpDir]) {
        _cachePath = path;
    } else {
        if ([path length] != 0) {
            _cachePath = [tmpDir stringByAppendingPathComponent:path];
        } else {
            return nil;
        }
    }
    _maxMemoryCacheNumber = maxNumber;
    
    if (self = [super init]) {
        _fileManager = [NSFileManager defaultManager];
        if ([_fileManager fileExistsAtPath:_cachePath isDirectory:nil] == NO) {
            // create the directory
            BOOL res = [_fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            if (!res) {
                DebugLogError(@"file cache directory create failed! The path is %@", _cachePath);
                return nil;
            }
        }
        _memoryCache = [[NSMutableDictionary alloc] initWithCapacity:_maxMemoryCacheNumber + 1];
        _memoryCacheKeys = [[NSMutableArray alloc] initWithCapacity:_maxMemoryCacheNumber + 1];
        return self;
    }
    return nil;
}

#pragma mark - 清除缓存
- (void)clear {
    _memoryCache = [[NSMutableDictionary alloc] initWithCapacity:_maxMemoryCacheNumber + 1];
    _memoryCacheKeys = [[NSMutableArray alloc] initWithCapacity:_maxMemoryCacheNumber + 1];
    
    // remove all the file in temporary
    NSArray * files = [self.fileManager contentsOfDirectoryAtPath:self.cachePath error:nil];
    for (NSString * file in files) {
        if (debugMode) {
            DebugLog(@"remove cache file: %@", file);
        }
        [self.fileManager removeItemAtPath:file error:nil];
    }
}

#pragma mark - 检查缓存大小,如果超出设定最大值，则移除最前面的旧值
- (void) checkCacheSize {
    if ([self.memoryCache count] > _maxMemoryCacheNumber) {
        NSString * key = [self.memoryCacheKeys objectAtIndex:0];
        [self.memoryCache removeObjectForKey:key];
        [self.memoryCacheKeys removeObjectAtIndex:0];
        if (debugMode) {
            DebugLog(@"remove oldest cache from memory: %@", key);
        }
    }
}

#pragma mark - 存储图片
- (void) putImage:(NSData *) imageData withName:(NSString*)imageName {
    if (imageData == nil) {
        if (debugMode) {
            DebugLog(@"image data is nil");
        }
        return;
    }
    
    [self.memoryCache setObject:imageData forKey:imageName];
    [self.memoryCacheKeys addObject:imageName];
    [self checkCacheSize];
    
    NSString * path = [self.cachePath stringByAppendingPathComponent:imageName];
    [imageData writeToFile:path atomically:YES];
    if (debugMode) {
        DebugLog(@"LTImageCache put cache image to %@", path);
    }
}

#pragma mark - 提取图片
- (NSData *) getImage:(NSString *)imageName {
    NSData * data = [self.memoryCache objectForKey:imageName];
    if (data != nil) {
        if (debugMode) {
            DebugLog(@"LTImageCache hit cache from memory: %@", imageName);
        }
        self.lastCacheKitStatus = LastCacheKitStatusInMemory;
        return data;
    }
    
    NSString * path = [self.cachePath stringByAppendingPathComponent:imageName];
    if ([self.fileManager fileExistsAtPath:path]) {
        if (debugMode) {
            DebugLog(@"LTImageCache hit cache from file %@", path);
        }
        data = [NSData dataWithContentsOfFile:path];
        // put it to memeory
        [self.memoryCache setObject:data forKey:imageName];
        [self.memoryCacheKeys addObject:imageName];
        [self checkCacheSize];
        self.lastCacheKitStatus = LastCacheKitStatusInDisk;
        return data;
    }
    self.lastCacheKitStatus = LastCacheKitStatusNotFound;
    return nil;
}

#pragma mark - 校验文件名
+ (NSString *)parseUrlForCacheName:(NSString *)name {
    if (name == nil) {
        return nil;
    }
    name = [name stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"://" withString:@"-"];
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    name = [NSString stringWithFormat:@"%@.png", name];
    // debugLog(@"dest video url cache name :%@", name);
    return name;
}


@end
