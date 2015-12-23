//
//  LTAliasSettingViewController.m
//  RCS
//
//  Created by zyq on 15/12/22.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTAliasSettingViewController.h"
#import "LTCommonTableDelegate.h"
#import "LTCommonTableData.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import <NIMUser.h>
#import <NIMSDK.h>

@interface LTAliasSettingViewController () <UITextFieldDelegate>
@property (nonatomic,strong) LTCommonTableDelegate  *delegator;
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,copy) NSString *alias;
@property (nonatomic,assign) NSInteger inputLimit;
@property (nonatomic,strong) NIMUser *user;
@end

@implementation LTAliasSettingViewController

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _inputLimit = 16;
        _user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavi];
    self.navigationItem.title = @"备注名";
    __weak typeof(self) weakSelf = self;
    self.alias = self.user.alias;
    [self buildData];
    self.delegator = [[LTCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return weakSelf.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self.delegator;
    self.tableView.dataSource = self.delegator;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onTextFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                [subView becomeFirstResponder];
                break;
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpNavi {
    self.navigationItem.title = @"签名";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)onDone:(id)sender {
    [self.view endEditing:YES];
    if (self.alias.length > self.inputLimit) {
        [self.view makeToast:@"设备名过长" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    self.user.alias = self.alias;
    [[NIMSDK sharedSDK].userManager updateUser:self.user completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [weakSelf.view makeToast:@"备注名设置成功" duration:2.0 position:CSToastPositionCenter];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.view makeToast:@"备注名设置失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)buildData {
    NSArray *data = @[
                      @{
                          HeaderTitle : @"",
                          RowContent  : @[
                                  @{
                                      ExtraInfo : self.alias.length ? self.alias : @"",
                                      CellClass : @"NTESTextSettingCell",
                                      RowHeight : @(50),
                                      },
                                  ],
                          },
                      ];
    self.data = [LTCommonTableSection sectionsWithData:data];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
    self.alias = textField.text;
}


#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}





























































@end
