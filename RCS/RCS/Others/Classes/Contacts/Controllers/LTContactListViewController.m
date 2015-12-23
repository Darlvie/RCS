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
#import "LTSearchTeamViewController.h"
#import "NTESContactUtilCell.h"
#import "NIMContactDataCell.h"
#import "UIAlertView+NTESBlock.h"
#import "LTGroupedDataCollection.h"
#import "LTPersonalCardViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface LTContactListViewController ()
<NIMSystemNotificationManagerDelegate,
NIMLoginManagerDelegate,
NIMUserManagerDelegate,
UITableViewDataSource,
UITableViewDelegate,
NTESContactUtilCellDelegate,
NIMContactDataCellDelegate>
{
    UIRefreshControl *_refreshControl;
    LTGroupedContacts *_contacts;
}

@end

@implementation LTContactListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置导航左侧菜单按钮
    [self setupLeftMenuButton];
    
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

/**
 *  设置导航栏左侧菜单按钮
 */
- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem *leftMenuButton = [[MMDrawerBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_btn"]
                                                                                   style:UIBarButtonItemStyleDone
                                                                                  target:self
                                                                                  action:@selector(leftMenuButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftMenuButton animated:YES];
}

/**
 *  点击导航栏左侧菜单按钮触发事件，打开左侧栏菜单
 */
- (void)leftMenuButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)prepareData {
    _contacts = [[LTGroupedContacts alloc] init];
    
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
                break;
                
            case 2:
            {
                vc = [[LTSearchTeamViewController alloc] initWithNibName:nil bundle:nil];
                break;
            }
                
            default:
                break;
        }
        if (vc) {
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contacts memberCountOfGroup:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_contacts groupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id contactItem = [_contacts memberOfIndex:indexPath];
    NSString *cellId = [contactItem reuseId];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        Class cellClazz = NSClassFromString([contactItem cellName]);
        cell = [[cellClazz alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if ([contactItem showAccessoryView]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([cell isKindOfClass:[NTESContactUtilCell class]]) {
        [(NTESContactUtilCell *)cell refreshWithContactItem:contactItem];
        [(NTESContactUtilCell *)cell setDelegate:self];
    } else {
        [(NIMContactDataCell *)cell refreshUser:contactItem];
        [(NIMContactDataCell *)cell setDelegate:self];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_contacts titleOfGroup:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _contacts.sortedGroupTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index + 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
    return [contactItem userId].length;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除好友"
                                                        message:@"删除好友后，将同时解除双方的好友关系"
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
        [alert showAlertWithCompletionHandler:^(NSInteger index) {
            if (index == 1) {
                [SVProgressHUD show];
                id<NTESContactItem,LTGroupedMemberProtocol> contactItem = (id<NTESContactItem,LTGroupedMemberProtocol>)[_contacts memberOfIndex:indexPath];
                NSString *userId = [contactItem userId];
                __weak typeof(self) weakSelf = self;
                [[NIMSDK sharedSDK].userManager deleteFriend:userId completion:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    if (!error) {
                        [_contacts removerGroupMember:contactItem];
                    } else {
                        [weakSelf.view makeToast:@"删除失败" duration:2.0 position:CSToastPositionCenter];
                    }
                }];
            }
        }];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
    if ([contactItem respondsToSelector:@selector(selName)] && [contactItem selName].length) {
        SEL sel = NSSelectorFromString([contactItem selName]);
        SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:nil]);
    } else if (contactItem.vcName.length) {
        Class clazz = NSClassFromString(contactItem.vcName);
        UIViewController *vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([contactItem respondsToSelector:@selector(userId)]) {
        NSString *friendId = contactItem.userId;
        [self enterPersonalCard:friendId];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
    return contactItem.uiHeight;
}

#pragma mark - NIMContactDataCellDelegate
- (void)onPressAvatar:(NSString *)memberId {
    [self enterPersonalCard:memberId];
}

#pragma mark - NTESContactUtilCellDelegate
- (void)onPressUtilImage:(NSString *)content {
    [self.view makeToast:[NSString stringWithFormat:@"点我干嘛 我是<%@>",content]
                duration:2.0
                position:CSToastPositionCenter];
}

#pragma mark - NIMSDK Delegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount {
    [self prepareData];
    [self.tableView reloadData];
}

- (void)onLogin:(NIMLoginStep)step {
    if (step == NIMLoginStepSyncOK) {
        if (self.isViewLoaded) {//没有加载view的话viewDidLoad里会走一遍prepareData
            [self prepareData];
            [self.tableView reloadData];
        }
    }
}

- (void)onFriendChanged:(NIMUser *)user {
    [self prepareData];
    [self.tableView reloadData];
}

- (void)onBlackListChanged {
    [self prepareData];
    [self.tableView reloadData];
}

- (void)onUserInfoChanged:(NIMUser *)user {
    [self prepareData];
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)presentMemberSelector:(ContactSelectFinishBlock) block{
    NSMutableArray *users = [[NSMutableArray alloc] init];
    //使用内置的好友选择器
    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
    //获取自己的id
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [users addObject:currentUserId];
    //将自己的id过滤
    config.filterIds = users;
    //需要多选
    config.needMutiSelected = YES;
    //初始化联系人选择器
    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
    //回调处理
    vc.finshBlock = block;
    [vc show];
}

- (void)enterPersonalCard:(NSString *)userId {
    LTPersonalCardViewController *vc = [[LTPersonalCardViewController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
