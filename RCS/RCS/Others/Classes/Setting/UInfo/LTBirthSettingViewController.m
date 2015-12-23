//
//  LTBirthSettingViewController.m
//  RCS
//
//  Created by zyq on 15/12/23.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTBirthSettingViewController.h"
#import "LTCommonTableDelegate.h"
#import "LTCommonTableData.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "UIView+NTES.h"
#import <NIMSDK.h>

@interface LTBirthSettingViewController ()
@property (nonatomic,strong) LTCommonTableDelegate *delegator;
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,copy) NSString *birth;
@end

@implementation LTBirthSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavi];
    NSString *userId = [[NIMSDK sharedSDK].loginManager currentAccount];
    self.birth = [[NIMSDK sharedSDK].userManager userInfo:userId].userInfo.birth;
    [self buildData];
    
    __weak typeof(self) weakSelf = self;
    self.delegator = [[LTCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return weakSelf.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate   = self.delegator;
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
}

- (void)setUpNavi{
    self.navigationItem.title = @"选择出生日期";
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
                                      Title         : @"生日",
                                      DetailTitle   : self.birth,
                                      CellAction    : @"onTouchBirthSetting:",
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

- (void)onTouchBirthSetting:(id)sender {
    
}





















@end
