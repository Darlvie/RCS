//
//  LTNickNameSettingViewController.m
//  RCS
//
//  Created by zyq on 15/12/23.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTNickNameSettingViewController.h"
#import "LTCommonTableDelegate.h"
#import "LTCommonTableData.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import <NIMSDK.h>

@interface LTNickNameSettingViewController () <UITextFieldDelegate>
@property (nonatomic,strong) LTCommonTableDelegate *delegator;
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,assign) NSInteger inputLimit;
@property (nonatomic,copy) NSString *nick;
@end

@implementation LTNickNameSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _inputLimit = 13;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavi];
    __weak typeof(self) weakSelf = self;
    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
    NIMUser *me = [[NIMSDK sharedSDK].userManager userInfo:uid];
    self.nick = me.userInfo.nickName;
    [self buildData];
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
    [self.tableView reloadData];
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                [subView becomeFirstResponder];
                break;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onTextFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)setUpNavi {
    self.navigationItem.title = @"昵称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)onDone:(id)sender {
    if (!self.nick.length) {
        [self.view makeToast:@"昵称不能为空" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.nick.length > self.inputLimit) {
        [self.view makeToast:@"昵称过长" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagNick):self.nick} completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [weakSelf.view makeToast:@"昵称设置成功" duration:2.0 position:CSToastPositionCenter];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.view makeToast:@"昵称设置失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)buildData {
    NSArray *data = @[
                      @{
                          HeaderHeight : @"",
                          RowContent   : @[
                                  @{
                                      ExtraInfo : self.nick,
                                      CellClass : @"NTESTextSettingCell",
                                      RowHeight : @(50),
                                      },
                                  ],
                          FooterHeight : @"好的昵称可以让你的朋友更容易记住你"
                          },
                      ];
    self.data = [LTCommonTableSection sectionsWithData:data];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //如果是删除键
    if ([string length] == 0 && range.length > 0) {
        return YES;
    }
    
    NSString *genString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.inputLimit && genString.length > self.inputLimit) {
        return NO;
    }
    return YES;
}

- (void)onTextFieldChanged:(NSNotification *)notification {
    UITextField *textField = notification.object;
    self.nick = textField.text;
}


#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}



















































@end
