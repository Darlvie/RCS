//
//  LTMyFilesViewController.m
//  RCS
//
//  Created by zyq on 15/10/23.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTMyFilesViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "UIColor+LTExtension.h"

@interface LTMyFilesViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@end

@implementation LTMyFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的文件";
    
    //设置导航左侧菜单按钮
    [self setupLeftMenuButton];
    
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(edit:)];
    
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置导航栏图标
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
 *  设置导航栏右侧编辑按钮的状态
 */
- (void)edit:(UIBarButtonItem *)sender {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    sender.tintColor = self.tableView.editing? [UIColor redColor] : [UIColor whiteColor];
    sender.title = self.tableView.editing? @"删除" : @"编辑";
}

/**
 *  设置表视图
 */
- (void)setupTableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    _tableView.opaque = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
   
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const identifier = @"myFileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"word_icon"];
                cell.textLabel.text = @"新闻.doc";
            }
                break;
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"excel_icon"];
                cell.textLabel.text = @"名单.xml";
            }
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"ppt_icon"];
                cell.textLabel.text = @"报告.ppt";
            }
                break;
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"video_icon"];
                cell.textLabel.text = @"新闻视频";
            }
                break;
            case 2:
            {
                cell.imageView.image = [UIImage imageNamed:@"excel_icon"];
                cell.textLabel.text = @"报表.xml";
            }
                
            default:
                break;
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];

    
    NSString *headerStr = nil;
  
    switch (section) {
        case 0:
            headerStr = @"已下载文件";;
            break;
        case 1:
            headerStr = @"本地文件";
        default:
            break;
    }
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.textColor = UIColorFromHexValue(0x5070b9);
    headerLabel.text = headerStr;
    
    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 40.f;
    return height;
}

@end
