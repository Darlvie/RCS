//
//  LTPersonalCardViewController.m
//  RCS
//
//  Created by zyq on 15/12/21.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTPersonalCardViewController.h"
#import <NIMUserManagerProtocol.h>
#import "LTCommonTableDelegate.h"
#import <NIMUser.h>
#import <NIMSDK.h>
#import "NTESUserUtil.h"
#import "LTCommonTableData.h"
#import "NTESColorButtonCell.h"
#import "UIView+NTES.h"
#import "LTAliasSettingViewController.h"
#import "LTUserInfoSettingViewController.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "LTSessionViewController.h"
#import "NTESBundleSetting.h"
#import "UIAlertView+NTESBlock.h"

@interface LTPersonalCardViewController () <NIMUserManagerDelegate>
@property (nonatomic,strong) LTCommonTableDelegate *delegator;
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong) NIMUser *user;
@end

@implementation LTPersonalCardViewController

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (void)dealloc {
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNav];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    self.delegator = [[LTCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return weakSelf.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self.delegator;
    self.tableView.dataSource = self.delegator;
    [self refresh];
}

- (void)setUpNav {
    self.navigationItem.title = @"个人名片";
    if ([self.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(onActionEditMyInfo:)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    }
}

- (void)refresh {
    self.user = [[NIMSDK sharedSDK].userManager userInfo:self.userId];
    [self buildData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildData{
    BOOL isMe          = [self.userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount];
    BOOL isMyFriend    = [NTESUserUtil isMyFriend:self.userId];
    BOOL isInBlackList = [[NIMSDK sharedSDK].userManager isUserInBlackList:self.userId];
    BOOL needNotify    = [[NIMSDK sharedSDK].userManager notifyForNewMsg:self.userId];
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : self.userId.length ? self.user.userId : [NSNull null],
                                      CellClass     : @"NTESCardPortraitCell",
                                      RowHeight     : @(100),
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"备注名",
                                      DetailTitle  : self.user.alias.length ? self.user.alias : @"",
                                      CellAction   : @"onActionEditAlias:",
                                      ShowAccessory: @(YES),
                                      Disable      : @(!isMyFriend),
                                      },
                                  @{
                                      Title        : @"生日",
                                      DetailTitle  : self.user.userInfo.birth.length ? self.user.userInfo.birth : @"",
                                      Disable      : @(!self.user.userInfo.birth.length),
                                      },
                                  @{
                                      Title        : @"手机",
                                      DetailTitle  : self.user.userInfo.mobile.length ? self.user.userInfo.mobile : @"",
                                      Disable      : @(!self.user.userInfo.mobile.length),
                                      },
                                  @{
                                      Title        : @"邮箱",
                                      DetailTitle  : self.user.userInfo.email.length ? self.user.userInfo.email : @"",
                                      Disable      : @(!self.user.userInfo.email.length),
                                      },
                                  @{
                                      Title        : @"签名",
                                      DetailTitle  : self.user.userInfo.sign.length ? self.user.userInfo.sign : @"",
                                      Disable      : @(!self.user.userInfo.sign.length),
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"消息提醒",
                                      CellClass    : @"NTESSettingSwitcherCell",
                                      CellAction   : @"onActionNeedNotifyValueChange:",
                                      ExtraInfo    : @(needNotify),
                                      Disable      : @(isMe),
                                      ForbidSelect : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"黑名单",
                                      CellClass    : @"NTESSettingSwitcherCell",
                                      CellAction   : @"onActionBlackListValueChange:",
                                      ExtraInfo    : @(isInBlackList),
                                      Disable      : @(isMe),
                                      ForbidSelect : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"聊天",
                                      CellClass    : @"NTESColorButtonCell",
                                      CellAction   : @"chat",
                                      ExtraInfo    : @(ColorButtonCellStyleBlue),
                                      Disable      : @(isMe),
                                      RowHeight    : @(60),
                                      ForbidSelect : @(YES),
                                      SepLeftEdge  : @(self.view.width),
                                      },
                                  @{
                                      Title        : @"删除好友",
                                      CellClass    : @"NTESColorButtonCell",
                                      CellAction   : @"deleteFriend",
                                      ExtraInfo    : @(ColorButtonCellStyleRed),
                                      Disable      : @(!isMyFriend || isMe),
                                      RowHeight    : @(60),
                                      ForbidSelect : @(YES),
                                      SepLeftEdge  : @(self.view.width),
                                      },
                                  @{
                                      Title        : @"添加好友",
                                      CellClass    : @"NTESColorButtonCell",
                                      CellAction   : @"addFriend",
                                      ExtraInfo    : @(ColorButtonCellStyleBlue),
                                      Disable      : @(isMyFriend  || isMe),
                                      RowHeight    : @(60),
                                      ForbidSelect : @(YES),
                                      SepLeftEdge  : @(self.view.width),
                                      },
                                  ],
                          FooterTitle:@"",
                          },
                      ];
    self.data = [LTCommonTableSection sectionsWithData:data];
}

#pragma mark - Action
- (void)onActionEditAlias:(id)sender {
    LTAliasSettingViewController *aliasVC = [[LTAliasSettingViewController alloc] initWithUserId:self.userId];
    [self.navigationController pushViewController:aliasVC animated:YES];
}

- (void)onActionEditMyInfo:(id)sender {
    LTUserInfoSettingViewController *userInfoVC = [[LTUserInfoSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (void)onActionBlackListValueChange:(id)sender {
    UISwitch *switcher = sender;
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    if (switcher.on) {
        [[NIMSDK sharedSDK].userManager addToBlackList:self.userId completion:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                [weakSelf.view makeToast:@"拉黑成功" duration:2.0 position:CSToastPositionCenter];
            } else {
                [weakSelf.view makeToast:@"拉黑失败" duration:2.0 position:CSToastPositionCenter];
                [weakSelf refresh];
            }
        }];
    } else {
        [[NIMSDK sharedSDK].userManager removeFromBlackBlackList:self.userId completion:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                [weakSelf.view makeToast:@"移除黑名单成功" duration:2.0 position:CSToastPositionCenter];
            } else {
                [weakSelf.view makeToast:@"移除黑名单失败" duration:2.0 position:CSToastPositionCenter];
                [weakSelf refresh];
            }
        }];
    }
}

- (void)onActionNeedNotifyValueChange:(id)sender {
    UISwitch *switcher = sender;
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].userManager updateNotifyState:switcher.on forUser:self.userId completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [weakSelf.view makeToast:@"操作失败" duration:2.0 position:CSToastPositionCenter];
            [weakSelf refresh];
        }
    }];
}

- (void)chat {
    UINavigationController *navi = self.navigationController;
    NIMSession *session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
    LTSessionViewController *sessionVC = [[LTSessionViewController alloc] initWithSession:session];
    [navi pushViewController:sessionVC animated:YES];
    UIViewController *root = navi.viewControllers[0];
    navi.viewControllers = @[root,sessionVC];
}

- (void)addFriend {
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = self.userId;
    request.operation = NIMUserOperationAdd;
    if ([[NTESBundleSetting sharedConfig] needVerifyForFriend]) {
        request.operation = NIMUserOperationRequest;
        request.message = @"跪求通过";
    }
    NSString *successText = request.operation == NIMUserOperationAdd ? @"添加成功" : @"请求成功";
    NSString *failedText = request.operation == NIMUserOperationAdd ? @"添加失败" : @"请求失败";
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [weakSelf.view makeToast:successText duration:2.0 position:CSToastPositionCenter];
            [weakSelf refresh];
        } else {
            [weakSelf.view makeToast:failedText duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)deleteFriend {
    __weak typeof(self) weakSelf = self;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除好友"
                                                    message:@"删除好友后，将同时解除双方的好友关系"
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        if (index == 1) {
            [SVProgressHUD show];
            [[NIMSDK sharedSDK].userManager deleteFriend:weakSelf.userId completion:^(NSError *error) {
                [SVProgressHUD dismiss];
                if (!error) {
                    [weakSelf.view makeToast:@"删除成功" duration:2.0 position:CSToastPositionCenter];
                } else {
                    [weakSelf.view makeToast:@"删除失败" duration:2.0 position:CSToastPositionCenter];
                }
            }];
        }
    }];
}


#pragma mark - NIMUserManagerDelegate
- (void)onUserInfoChanged:(NIMUser *)user {
    if ([user.userId isEqualToString:self.userId]) {
        [self refresh];
    }
}

- (void)onFriendChanged:(NIMUser *)user {
    if ([user.userId isEqualToString:self.userId]) {
        [self refresh];
    }
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}






























@end
