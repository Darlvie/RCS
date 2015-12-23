//
//  LTCommonTableDelegate.h
//  RCS
//
//  Created by zyq on 15/12/22.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LTCommonTableDelegate : NSObject <UITableViewDataSource,UITableViewDelegate>

- (instancetype)initWithTableData:(NSArray *(^)(void))data;

@property (nonatomic,assign) CGFloat defaultSeparatorLeftEdge;
@end
