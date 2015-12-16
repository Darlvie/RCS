//
//  LTChineseString.h
//  RCS
//
//  Created by zyq on 15/10/28.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTChineseString : NSObject

@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;

//-----  返回tableview右方indexArray
+ (NSMutableArray*)indexArray:(NSArray*)stringArr;

//-----  返回联系人
+ (NSMutableArray*)letterSortArray:(NSArray*)stringArr;


///----------------------
//返回一组字母排序数组(中英混排)
+ (NSMutableArray*)sortArray:(NSArray*)stringArr;
@end
