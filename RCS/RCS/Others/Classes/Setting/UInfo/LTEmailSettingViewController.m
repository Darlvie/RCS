//
//  LTEmailSettingViewController.m
//  RCS
//
//  Created by zyq on 15/12/23.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTEmailSettingViewController.h"
#import "LTCommonTableData.h"
#import "LTCommonTableDelegate.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import <NIMSDK.h>

@interface LTEmailSettingViewController () <UITextFieldDelegate>
@property (nonatomic,strong) LTCommonTableDelegate *delegator;
@property (nonatomic,assign) NSInteger inputLimit;
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,copy) NSString *email;
@end

@implementation LTEmailSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _inputLimit = 30;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置邮箱";
    [self setUpNavi];
    NSString *userId = [[NIMSDK sharedSDK].loginManager currentAccount];
    self.email = [[NIMSDK sharedSDK].userManager userInfo:userId].userInfo.email;
    __weak typeof(self) weakSelf = self;
    self.delegator = [[LTCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return weakSelf.data;
    }];
    [self buildData];
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavi {
    self.navigationItem.title = @"邮箱";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)onDone:(id)sender {
    [self.view endEditing:YES];
    if (self.email.length > self.inputLimit) {
        [self.view makeToast:@"邮箱过长" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagEmail) : self.email} completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            UINavigationController *navi = weakSelf.navigationController;
            [navi popViewControllerAnimated:YES];
            [navi.view makeToast:@"邮箱设置成功" duration:2.0 position:CSToastPositionCenter];
        } else {
            [weakSelf.view makeToast:@"邮箱设置失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}


- (void)buildData {
    NSArray *data = @[
                      @{
                          HeaderTitle : @"",
                          RowContent  : @[
                                  @{
                                      ExtraInfo : self.email,
                                      CellClass : @"NTESTextSettingCell",
                                      RowHeight : @(50),
                                      },
                                  ],
                          },
                      ];
    self.data = [LTCommonTableSection sectionsWithData:data];
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0 && range.length > 0) {
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
    self.email = textField.text;
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}


@end
