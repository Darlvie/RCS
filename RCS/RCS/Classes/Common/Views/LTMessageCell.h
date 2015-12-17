//
//  LTMessageCell.h
//  RCS
//
//  Created by zyq on 15/10/27.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTMessageFrameModel;
@interface LTMessageCell : UITableViewCell

@property(nonatomic,strong) LTMessageFrameModel *messageFrame;

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;
@end
