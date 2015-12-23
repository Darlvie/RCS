//
//  LTAliasSettingViewController.h
//  RCS
//
//  Created by zyq on 15/12/22.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTAliasSettingViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;
- (instancetype)initWithUserId:(NSString *)userId;
@end
