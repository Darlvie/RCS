//
//  LTSystemNotificationCell.h
//  RCS
//
//  Created by zyq on 15/12/24.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NotificationHandleType){
    NotificationHandleTypePending = 0,
    NotificationHandleTypeOk,
    NotificationHandleTypeNo,
    NotificationHandleTypeOutOfDate
};

@class NIMSystemNotification;

@protocol NIMSystemNotificationCellDelegate <NSObject>

- (void)onAccept:(NIMSystemNotification *)notification;
- (void)onRefuse:(NIMSystemNotification *)notification;

@end

@interface LTSystemNotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *handleInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;

@property (nonatomic,assign) id<NIMSystemNotificationCellDelegate> actionDelegate;

- (void)update:(NIMSystemNotification *)notification;
@end
