//
//  LTSystemNotificationViewController.m
//  RCS
//
//  Created by zyq on 15/12/24.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTSystemNotificationViewController.h"
#import "UIView+Toast.h"
#import <NIMKit.h>
#import "LTSystemNotificationCell.h"

static const NSInteger MaxNotificationCount = 20;
static NSString *reuseIdentifier = @"reuseIdentifier";


@interface LTSystemNotificationViewController () <NIMSystemNotificationManagerDelegate,NIMSystemNotificationCellDelegate,NIMTeamManagerDelegate>
@property (nonatomic,strong) NSMutableArray *notifications;
@property (nonatomic,assign) BOOL shouldMarkAsRead;
@end

@implementation LTSystemNotificationViewController

- (void)dealloc {
    if (_shouldMarkAsRead) {
        [[[NIMSDK sharedSDK] systemNotificationManager] markAllNotificationsAsRead];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.navigationItem.title = @"验证消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"LTSystemNotificationCell" bundle:nil]
         forCellReuseIdentifier:reuseIdentifier];
    _notifications = [NSMutableArray array];
    id<NIMSystemNotificationManager> systemNotificationManager = [[NIMSDK sharedSDK] systemNotificationManager];
    [systemNotificationManager addDelegate:self];
    
    NSArray *notifications = [systemNotificationManager fetchSystemNotifications:nil limit:MaxNotificationCount];
    if (notifications.count > 0) {
        [_notifications addObjectsFromArray:notifications];
        if (![[notifications firstObject] read]) {
            _shouldMarkAsRead = YES;
        }
    }
    if (notifications.count >= MaxNotificationCount) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(0, 0, 320, 40)];
        [button addTarget:self
                   action:@selector(loadMore:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"载入更多" forState:UIControlStateNormal];
        self.tableView.tableFooterView = button;
    } else {
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clearAll:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMore:(id)sender {
    NSArray *notifications = [[[NIMSDK sharedSDK] systemNotificationManager] fetchSystemNotifications:[_notifications lastObject]
                                                                                                limit:MaxNotificationCount];
    if ([notifications count]) {
        [_notifications addObjectsFromArray:notifications];
        [self.tableView reloadData];
    }
}

- (void)clearAll:(id)sender {
    [[[NIMSDK sharedSDK] systemNotificationManager] deleteAllNotifications];
    [_notifications removeAllObjects];
    [self.tableView reloadData];
}

- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification {
    [_notifications insertObject:notification atIndex:0];
    _shouldMarkAsRead = YES;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSystemNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NIMSystemNotification *notification = [_notifications objectAtIndex:indexPath.row];
    [cell update:notification];
    cell.actionDelegate = self;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = indexPath.row;
        NIMSystemNotification *notification = _notifications[index];
        [_notifications removeObjectAtIndex:index];
        [[[NIMSDK sharedSDK] systemNotificationManager] deleteNotification:notification];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SystemNotificationCell
- (void)onAccept:(NIMSystemNotification *)notification {
    __weak typeof(self) weakSelf = self;
    switch (notification.type) {
        case NIMSystemNotificationTypeTeamApply:
        {
            [[NIMSDK sharedSDK].teamManager passApplyToTeam:notification.targetID userId:notification.sourceID completion:^(NSError *error, NIMTeamApplyStatus applyStatus) {
                if (!error) {
                    [weakSelf.navigationController.view makeToast:@"同意成功"
                                                         duration:2.0
                                                         position:CSToastPositionCenter];
                    [weakSelf.tableView reloadData];
                } else {
                    if (error.code == NIMRemoteErrorCodeTimeoutError) {
                        [weakSelf.navigationController.view makeToast:@"网络问题，请重试"
                                                             duration:2
                                                             position:CSToastPositionCenter];
                    } else {
                        notification.handleStatus = NotificationHandleTypeOutOfDate;
                    }
                    [weakSelf.tableView reloadData];
                    DebugLogError(@"%@",error.localizedDescription);
                }
            }];
        }
            break;
        case NIMSystemNotificationTypeTeamInvite:
        {
            [[NIMSDK sharedSDK].teamManager acceptInviteWithTeam:notification.targetID invitorId:notification.sourceID completion:^(NSError *error) {
                if (!error) {
                    [weakSelf.navigationController.view makeToast:@"接受成功"
                                                         duration:2
                                                         position:CSToastPositionCenter];
                    notification.handleStatus = NotificationHandleTypeOk;
                    [weakSelf.tableView reloadData];
                } else {
                    if (error.code == NIMRemoteErrorCodeTimeoutError) {
                        [weakSelf.navigationController.view makeToast:@"网络问题，请重试"
                                                             duration:2
                                                             position:CSToastPositionCenter];
                    } else if(error.code == NIMRemoteErrorCodeTeamNotExists) {
                        [weakSelf.view makeToast:@"群不存在"
                                        duration:2
                                        position:CSToastPositionCenter];
                    } else {
                        notification.handleStatus = NotificationHandleTypeOutOfDate;
                    }
                    [weakSelf.tableView reloadData];
                    DebugLogError(@"%@",error.localizedDescription);
                    
                }
            }];
        }
            break;
        case NIMSystemNotificationTypeFriendAdd:
        {
            NIMUserRequest *request = [[NIMUserRequest alloc] init];
            request.userId = notification.sourceID;
            request.operation = NIMUserOperationVerify;
            [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
                if (!error) {
                    [weakSelf.navigationController.view makeToast:@"验证成功"
                                                         duration:2
                                                         position:CSToastPositionCenter];
                    notification.handleStatus = NotificationHandleTypeOk;
                } else {
                    [weakSelf.navigationController.view makeToast:@"验证失败，请重试"
                                                         duration:2
                                                         position:CSToastPositionCenter];
                }
                [weakSelf.tableView reloadData];
                DebugLogError(@"%@",error.localizedDescription);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)onRefuse:(NIMSystemNotification *)notification {
    __weak typeof(self) weakSelf = self;
    switch (notification.type) {
        case NIMSystemNotificationTypeTeamApply:
        {
            [[NIMSDK sharedSDK].teamManager rejectApplyToTeam:notification.targetID userId:notification.sourceID rejectReason:@"" completion:^(NSError *error) {
                if (!error) {
                    [weakSelf.navigationController.view makeToast:@"拒绝成功"
                                                         duration:2
                                                         position:CSToastPositionCenter];
                    notification.handleStatus = NotificationHandleTypeNo;
                    [weakSelf.tableView reloadData];
                } else {
                    if (error.code == NIMRemoteErrorCodeTimeoutError) {
                        [weakSelf.navigationController.view makeToast:@"网络问题，请重试"
                                                             duration:2
                                                             position:CSToastPositionCenter];
                    } else {
                        notification.handleStatus = NotificationHandleTypeOutOfDate;
                    }
                    [weakSelf.tableView reloadData];
                    DebugLogError(@"%@",error.localizedDescription);
                }
            }];
        }
            break;
        case NIMSystemNotificationTypeTeamInvite:
        {
            [[NIMSDK sharedSDK].teamManager rejectInviteWithTeam:notification.targetID invitorId:notification.sourceID rejectReason:@"" completion:^(NSError *error) {
                if (!error) {
                    [weakSelf.navigationController.view makeToast:@"拒绝成功"
                                                         duration:2
                                                         position:CSToastPositionCenter];
                    notification.handleStatus = NotificationHandleTypeNo;
                    [weakSelf.tableView reloadData];
                } else {
                    if (error.code == NIMRemoteErrorCodeTimeoutError) {
                        [weakSelf.navigationController.view makeToast:@"网络问题，请重试"
                                                             duration:2
                                                             position:CSToastPositionCenter];
                    } else if (error.code == NIMRemoteErrorCodeTeamNotExists) {
                        [weakSelf.navigationController.view makeToast:@"群不存在"
                                                             duration:2
                                                             position:CSToastPositionCenter];
                    }else {
                        notification.handleStatus = NotificationHandleTypeOutOfDate;
                    }
                    [weakSelf.tableView reloadData];
                    DebugLogError(@"%@",error.localizedDescription);
                }
            }];
        }
            break;
        case NIMSystemNotificationTypeFriendAdd:
        {
            NIMUserRequest *request = [[NIMUserRequest alloc] init];
            request.userId = notification.sourceID;
            request.operation = NIMUserOperationReject;
            
            [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
                if (!error) {
                    [weakSelf.navigationController.view makeToast:@"拒绝成功" duration:2 position:CSToastPositionCenter];
                    notification.handleStatus = NotificationHandleTypeNo;
                } else {
                    [weakSelf.navigationController.view makeToast:@"拒绝失败，请重试" duration:2 position:CSToastPositionCenter];
                    
                }
                [weakSelf.tableView reloadData];
                DebugLogError(@"%@",error.localizedDescription);

            }];
        }
            break;
            
        default:
            break;
    }
}



























@end
