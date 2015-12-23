//
//  LTContactAddFriendViewController.m
//  RCS
//
//  Created by zyq on 15/12/21.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTContactAddFriendViewController.h"
#import "LTPersonalCardViewController.h"
#import "LTCommonTableDelegate.h"
#import "LTCommonTableData.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import <NIMSDK.h>

@interface LTContactAddFriendViewController () <UITextFieldDelegate>
@property (nonatomic,strong) LTCommonTableDelegate *delegator;
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,assign) NSInteger inputLimit;
@end

@implementation LTContactAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加好友";
    self.navigationItem.rightBarButtonItem = nil;
    __weak typeof(self) weakSelf = self;
    [self buildData];
    self.delegator = [[LTCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return weakSelf.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self.delegator;
    self.tableView.delegate = self.delegator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildData {
    NSArray *data = @[
                      @{
                          HeaderTitle : @"",
                          RowContent : @[
                                  @{
                                      Title : @"请输入账号",
                                      CellClass : @"NTESTextSettingCell",
                                      RowHeight : @(50),
                                      },
                                  ],
                          FooterTitle : @"",
                          },
                      
                      ];
    self.data = [LTCommonTableSection sectionsWithData:data];
}

#pragma mark - Private
- (void)addFriend:(NSString *)userId {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId] completion:^(NSArray *users, NSError *error) {
        [SVProgressHUD dismiss];
        if (users.count) {
            LTPersonalCardViewController *cardVC = [[LTPersonalCardViewController alloc] initWithUserId:userId];
            [weakSelf.navigationController pushViewController:cardVC animated:YES];
        } else {
            if (weakSelf) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"改用户不存在"
                                                                message:@"请检查您输入的账号是否正确"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *userId = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (userId.length) {
        [self addFriend:userId];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}














@end
