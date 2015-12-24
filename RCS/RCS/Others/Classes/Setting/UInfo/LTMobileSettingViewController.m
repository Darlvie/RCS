//
//  LTMobileSettingViewController.m
//  RCS
//
//  Created by zyq on 15/12/23.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTMobileSettingViewController.h"
#import "LTCommonTableData.h"
#import "LTCommonTableDelegate.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import <NIMSDK.h>

@interface LTMobileSettingViewController () <UITextFieldDelegate>
@property (nonatomic,strong) LTCommonTableDelegate *delegator;
@property (nonatomic,assign) NSInteger inputLimit;
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,copy) NSString *mobile;
@end

@implementation LTMobileSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _inputLimit = 50;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavi];
    NSString *userId = [[NIMSDK sharedSDK].loginManager currentAccount];
    self.mobile = [[NIMSDK sharedSDK].userManager userInfo:userId].userInfo.mobile;
    __weak typeof(self) weakSelf = self;
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
    self.navigationItem.title = @"手机号码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)onDone:(id)sender {
    [self.view endEditing:YES];
    if (self.mobile.length > self.inputLimit) {
        [self.view makeToast:@"手机号码过长" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagMobile):self.mobile} completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            UINavigationController *navi = weakSelf.navigationController;
            [navi popViewControllerAnimated:YES];
            
            [navi.view makeToast:@"手机设置成功" duration:2.0 position:CSToastPositionCenter];
        } else {
            [weakSelf.view makeToast:@"手机设置失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)buildData {
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : self.mobile,
                                      CellClass     : @"NTESTextSettingCell",
                                      RowHeight     : @(50),
                                      },
                                  ],
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
    self.mobile = textField.text;
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}



















@end