//
//  LTContactListViewController.m
//  RCS
//
//  Created by zyq on 15/12/18.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTContactListViewController.h"
#import "NIMSDK.h"
#import "NTESContactUtilItem.h"
#import "UIActionSheet+NTESBlock.h"
#import "LTContactAddFriendViewController.h"
#import "NIMContactSelectViewController.h"
#import "SVProgressHUD.h"
#import "LTSessionViewController.h"
#import "UIView+Toast.h"

@interface LTContactListViewController ()
<NIMSystemNotificationManagerDelegate,
NIMLoginManagerDelegate,
NIMUserManagerDelegate>
{
    UIRefreshControl *_refreshControl;
    LTGroupedContacts *_contacts;
}

@end

@implementation LTContactListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIEdgeInsets separatorInset = self.tableView.separatorInset;
    separatorInset.right        = 0;
    self.tableView.separatorInset = separatorInset;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[[NIMSDK sharedSDK] userManager] addDelegate:self];
    
    [self prepareData];
}

- (void)dealloc {
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] userManager] removeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private

- (void)prepareData {
    NSString *contactCellUtilIcon = @"icon";
    NSString *contactCellUtilVC   = @"vc";
    NSString *contactCellUtilBadge = @"badge";
    NSString *contactCellUtilTitle = @"title";
    NSString *contactCellUtilUid   = @"uid";
    NSString *contactCellUtilSelectorName = @"selName";
    
    NSInteger systemCount = [[[NIMSDK sharedSDK] systemNotificationManager] allUnreadCount];
    NSMutableArray *utils = [@[@{contactCellUtilIcon:@"icon_notification_normal",
                                 contactCellUtilTitle:@"验证消息",
                                 contactCellUtilVC:@"",
                                 contactCellUtilBadge:@(systemCount)
                                 },
                               @{contactCellUtilIcon:@"icon_team_advance_normal",
                                 contactCellUtilTitle:@"高级群",
                                 contactCellUtilVC:@"",
                               },
                               @{contactCellUtilIcon:@"icon_blacklist_normal",
                                 contactCellUtilTitle:@"黑名单",
                                 contactCellUtilVC:@""
                                 },
                               ] mutableCopy];
    
    self.navigationItem.title = @"通讯录";
    [self setUpNaviItem];
    
    //构造显示的数据模型
    NTESContactUtilItem *contactUtil = [[NTESContactUtilItem alloc] init];
    NSMutableArray *members = [[NSMutableArray alloc] init];
    for (NSDictionary *item in utils) {
        NTESContactUtilMember *utilItem = [[NTESContactUtilMember alloc] init];
        utilItem.nick = item[contactCellUtilTitle];
        utilItem.icon = [UIImage imageNamed:item[contactCellUtilIcon]];
        utilItem.vcName = item[contactCellUtilVC];
        utilItem.badge = [item[contactCellUtilBadge] stringValue];
        utilItem.userId = item[contactCellUtilUid];
        utilItem.selName = item[contactCellUtilSelectorName];
        [members addObject:utilItem];
    }
    contactUtil.members = members;
    [_contacts addGroupAboveWithTitle:@"" members:contactUtil.members];
}

- (void)setUpNaviItem {
    UIButton *teamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [teamBtn addTarget:self action:@selector(onOpera:) forControlEvents:UIControlEventTouchUpInside];
    [teamBtn setImage:[UIImage imageNamed:@"icon_tinfo_normal"] forState:UIControlStateNormal];
    [teamBtn setImage:[UIImage imageNamed:@"icon_tinfo_pressed"] forState:UIControlStateHighlighted];
    [teamBtn sizeToFit];
    UIBarButtonItem *teamItem = [[UIBarButtonItem alloc] initWithCustomView:teamBtn];
    self.navigationItem.rightBarButtonItem = teamItem;
}


#pragma mark - Action
- (void)onOpera:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作"
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"添加好友",@"创建高级群",@"搜索高级群", nil];
    __weak typeof(self) weakSelf = self;
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        UIViewController *vc;
        switch (index) {
            case 0:
                vc = [[LTContactAddFriendViewController alloc] initWithNibName:nil bundle:nil];
                break;
            case 1://创建高级群
            {
                [weakSelf presentMemberSelector:^(NSArray *uids) {
                    NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
                    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
                    option.name = @"高级群";
                    option.type = NIMTeamTypeAdvanced;
                    option.joinMode = NIMTeamJoinModeNoAuth;
                    option.postscript = @"邀请您加入群组";
                    [SVProgressHUD show];
                    
                    [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId) {
                        [SVProgressHUD dismiss];
                        if (!error) {
                            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                            LTSessionViewController *sessionVC = [[LTSessionViewController alloc] initWithSession:session];
                            [weakSelf.navigationController pushViewController:sessionVC animated:YES];
                        } else {
                            [weakSelf.view makeToast:@"创建失败" duration:2.0 position:CSToastPositionCenter];
                        }
                    }];
                }];
            }
            case 2:
            {
                vc = [NTESContactAvatarAndAccessorySpacing]
            }
            default:
                break;
        }
    }];
}













- (void)presentMemberSelector:(ContactSelectFinishBlock) block{
    
}





@end
