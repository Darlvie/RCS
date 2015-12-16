//
//  LTChatViewController.m
//  RCS
//
//  Created by zyq on 15/10/22.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTChatListViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "LTChatListViewCell.h"
#import "LTBaseChatViewController.h"
#import "Masonry.h"
#import "LTBaiduMapViewController.h"

@interface LTChatListViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *chatListTableView;
@end

@implementation LTChatListViewController

static NSString * const reuseIdentifier = @"chatCell";


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"集训通";
    
    //设置导航左侧菜单按钮
    [self setupLeftMenuButton];
    
    //设置导航栏右侧查找按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_btn"]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
             
                                                                             action:@selector(searchChat)];
    [self setupChatListTableView];
    //注册cell
    [self.chatListTableView registerNib:[UINib nibWithNibName:@"LTChatListViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.chatListTableView.rowHeight = 80;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupNavi

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

/**
 *  点击导航栏右侧查询按钮触发事件
 */
- (void)searchChat {
    LTBaiduMapViewController *mapVC = [[LTBaiduMapViewController alloc]init];
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)setupChatListTableView {
    if (!_chatListTableView) {
        _chatListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH - 44)
                                                         style:UITableViewStyleGrouped];
    }
    _chatListTableView.opaque = YES;
    _chatListTableView.delegate = self;
    _chatListTableView.dataSource = self;
    _chatListTableView.backgroundColor = [UIColor whiteColor];
    _chatListTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_chatListTableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LTChatListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.avatarImageView.image = [UIImage imageNamed:@"avatar03"];
    cell.userNameLabel.text = @"张三";
    cell.contentLabel.text = @"testtesttesttesttest";
    cell.timestampLabel.text = @"6:43 PM";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LTBaseChatViewController *baseChatVC = [[LTBaseChatViewController alloc]init];
    [self.navigationController pushViewController:baseChatVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 0.0, 300.0, 44.0)];
    
    NSString *headerStr = nil;
    switch (section) {
        case 0:
            headerStr = @"今天 10.28";
            break;
        case 1:
            headerStr = @"昨天 10.27";
            break;
        case 2:
            headerStr = @"10.26";
        default:
            break;
    }
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(15.0, 0.0, 300.0, 44.0);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.textColor = UIColorFromHexValue(0x5070b9);
    headerLabel.text = headerStr;
    
    [customView addSubview:headerLabel];
    
    return customView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 44.f;
    return height;
}

@end
