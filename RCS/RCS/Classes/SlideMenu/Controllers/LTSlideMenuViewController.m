//
//  LTSlideMenuViewController.m
//  RCS
//
//  Created by zyq on 15/10/22.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTSlideMenuViewController.h"
#import "LTSlideMenuHeaderView.h"
#import "UIViewController+MMDrawerController.h"
#import "Masonry.h"
#import "UIImage+LTRoundIcon.h"
#import "UIColor+LTExtension.h"

#import "LTNavigationController.h"
#import "LTChatListViewController.h"
#import "LTContactsViewController.h"
#import "LTMyFilesViewController.h"
#import "LTLoginViewController.h"


typedef NS_ENUM(NSUInteger, SlideMenuCellType) {
    SlideMenuCellTypeChat,
    SlideMenuCellTypeContacts,
    SlideMenuCellTypeMyFile
};

@interface LTSlideMenuViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) LTSlideMenuHeaderView *headerView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *lineView;
@end

@implementation LTSlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置头部视图
    [self setupHeaderView];
    //设置表视图
    [self setupTableView];
    //设置划线视图
    [self setupLineView];
    //添加约束
    [self addConstraints];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化视图
/**
 *  设置头部视图
 */
- (void)setupHeaderView {
    if (_headerView == nil) {
        _headerView = [LTSlideMenuHeaderView headerView];
    }
    UIImage *avatarImage = [UIImage imageWithIconName:@"avatar01.jpeg" border:0 borderColor:nil scale:1];
    _headerView.avatarImageView.image = avatarImage;
    [_headerView.menuEditButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
}

/**
 *  设置选择菜单
 */
- (void)setupTableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
    }
    _tableView.opaque = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

/**
 *  画线条
 */
- (void)setupLineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
    }
    [_lineView setBackgroundColor:UIColorFromHexValue(0xe5e5e5)];
    [self.view addSubview:_lineView];
}

#pragma mark - 添加约束
/**
 *  添加约束
 */
- (void)addConstraints {
    //头部视图的约束
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@180);
    }];
    
    //菜单视图的约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //设置划线视图的约束
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(44*3 + 185));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
}

//退出登录
- (void)logout {
    LTLoginViewController *loginVC = [[LTLoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const identifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (indexPath.row) {
        case SlideMenuCellTypeChat:
        {
            cell.imageView.image = [UIImage imageNamed:@"menu_chat"];
            cell.imageView.highlightedImage = [UIImage imageNamed:@"menu_chat_active"];
            cell.textLabel.text = @"聊天";
        }
            break;
        case SlideMenuCellTypeContacts:
        {
            cell.imageView.image = [UIImage imageNamed:@"menu_contact"];
            cell.imageView.highlightedImage = [UIImage imageNamed:@"menu_contact_active"];
            cell.textLabel.text = @"通讯录";
        }
            break;
            
        case SlideMenuCellTypeMyFile:
        {
            cell.imageView.image = [UIImage imageNamed:@"menu_file"];
            cell.imageView.highlightedImage = [UIImage imageNamed:@"menu_file_active"];
            cell.textLabel.text = @"我的文件";
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case SlideMenuCellTypeChat:
        {
            LTChatListViewController *chatVC = [[LTChatListViewController alloc]init];
            LTNavigationController *navi = [[LTNavigationController alloc]initWithRootViewController:chatVC];
            [self.mm_drawerController setCenterViewController:navi withCloseAnimation:YES completion:nil];
        }
            break;
            
        case SlideMenuCellTypeContacts:
        {
            LTContactsViewController *constactsVC = [[LTContactsViewController alloc]init];
            LTNavigationController *navi = [[LTNavigationController alloc]initWithRootViewController:constactsVC];
            [self.mm_drawerController setCenterViewController:navi withCloseAnimation:YES completion:nil];
        }
            break;
        case SlideMenuCellTypeMyFile:
        {
            LTMyFilesViewController *myFileVC = [[LTMyFilesViewController alloc]init];
            LTNavigationController *navi = [[LTNavigationController alloc] initWithRootViewController:myFileVC];
            [self.mm_drawerController setCenterViewController:navi withCloseAnimation:YES completion:nil];
        }
            
        default:
            break;
    }
}

/**
 *  设置状态栏风格
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
