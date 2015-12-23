//
//  LTGenderSettingViewController.m
//  RCS
//
//  Created by zyq on 15/12/23.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTGenderSettingViewController.h"
#import "LTCommonTableData.h"
#import "LTCommonTableDelegate.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import <NIMSDK.h>

@interface LTGenderSettingViewController ()
@property (nonatomic,strong) LTCommonTableDelegate *delegator;
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,assign) NIMUserGender selectedGender;

@end

@implementation LTGenderSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavi];
    NSString *userId = [[NIMSDK sharedSDK].loginManager currentAccount];
    self.selectedGender = [[NIMSDK sharedSDK].userManager userInfo:userId].userInfo.gender;
    [self buildData];
    __weak typeof(self) weakSelf = self;
    self.delegator = [[LTCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return weakSelf.data;
    }];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self.delegator;
    self.tableView.dataSource = self.delegator;
}

- (void)setUpNavi {
    self.navigationItem.title = @"性别";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildData {
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title         : @"男",
                                      CellClass     : @"NTESSettingCheckCell",
                                      RowHeight     : @(50),
                                      CellAction    : @"onTouchMaleCell:",
                                      ExtraInfo     : @(self.selectedGender == NIMUserGenderMale),
                                      ForbidSelect  : @(YES),
                                      },
                                  @{
                                      Title         : @"女",
                                      CellClass     : @"NTESSettingCheckCell",
                                      RowHeight     : @(50),
                                      CellAction    : @"onTouchFemaleCell:",
                                      ExtraInfo     : @(self.selectedGender == NIMUserGenderFemale),
                                      ForbidSelect  : @(YES),
                                      },
                                  @{
                                      Title         : @"其他",
                                      CellClass     : @"NTESSettingCheckCell",
                                      CellAction    : @"onTouchUnkownGenderCell:",
                                      RowHeight     : @(50),
                                      ExtraInfo     : @(self.selectedGender == NIMUserGenderUnknown),
                                      ForbidSelect  : @(YES),
                                      },
                                  ],
                          },
                      ];
    self.data = [LTCommonTableSection sectionsWithData:data];
}

- (void)refresh {
    [self buildData];
    [self.tableView reloadData];
}

- (void)onTouchMaleCell:(id)sender {
    self.selectedGender = NIMUserGenderMale;
    [self remoteUpdateGender];
    [self refresh];
}

- (void)onTouchFemaleCell:(id)sender{
    self.selectedGender = NIMUserGenderFemale;
    [self remoteUpdateGender];
    [self refresh];
}

- (void)onTouchUnkownGenderCell:(id)sender {
    self.selectedGender = NIMUserGenderUnknown;
    [self remoteUpdateGender];
    [self refresh];
}

- (void)remoteUpdateGender {
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagGender):@(self.selectedGender)} completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            UINavigationController *navi = weakSelf.navigationController;
            [navi.view makeToast:@"性别设置成功" duration:2.0 position:CSToastPositionCenter];
            [navi popViewControllerAnimated:YES];
        } else {
        
            [weakSelf.view makeToast:@"性别试着失败，请重试" duration:2.0 position:CSToastPositionCenter];
            [self refresh];
        }
    }];
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}
















@end
