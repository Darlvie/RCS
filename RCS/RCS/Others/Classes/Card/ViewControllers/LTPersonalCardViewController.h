//
//  LTPersonalCardViewController.h
//  RCS
//
//  Created by zyq on 15/12/21.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactDataMember;
@interface LTPersonalCardViewController : UIViewController

- (instancetype)initWithUserId:(NSString *)userId;
@property (nonatomic,strong) UITableView *tableView;
@end
