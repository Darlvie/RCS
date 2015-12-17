//
//  LTContactsViewController.m
//  RCS
//
//  Created by zyq on 15/10/23.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTContactsViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "Masonry.h"
#import "LTContactModel.h"
#import "LTChineseString.h"

@interface LTContactsViewController () <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *contactsArray;
@property(nonatomic,strong) NSMutableArray *indexArray;
@property(nonatomic,strong) NSMutableArray *letterArray;
@end

@implementation LTContactsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    //设置导航左侧菜单按钮
    [self setupLeftMenuButton];
    
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"contact_add_btn"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(addContacts)];
    
    self.contactsArray = @[@"马云",@"马化腾",@"李彦宏",@"比尔盖茨",@"乔布斯",@"扎克伯格",@"雷军"];
    
    self.indexArray = [LTChineseString indexArray:self.contactsArray];
    self.letterArray = [LTChineseString letterSortArray:self.contactsArray];
    
    [self setupTableView];
    
    //[self setupConstrains];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addContacts {
    
}


- (void)setupTableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH - 44)
                                                 style:UITableViewStyleGrouped];
    }
    _tableView.opaque = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSelectionStyleBlue;
    //设置索引颜色
    _tableView.sectionIndexColor = UIColorFromHexValue(0x5070b9);
    [self.view addSubview:_tableView];
}


- (void)setupConstrains {
 
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

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

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
            
        default:
            return [[self.letterArray objectAtIndex:section - 2] count];
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const identifier = @"contactsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"cmd_img"];
            cell.textLabel.text = @"控制台";
        }
            break;
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:@"avatar02.jpeg"];
            cell.textLabel.text = @"新闻群组";
        }
            break;
            
        default:
            cell.imageView.image = [UIImage imageNamed:@"avatar03"];
            cell.textLabel.text = [[self.letterArray objectAtIndex:indexPath.section -2] objectAtIndex:indexPath.row];;
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
            return @"聊天群组";
            break;
            
        default:
            return [self.indexArray objectAtIndex:section - 2];
            break;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 0.0, 300.0, 44.0)];
    
    
    NSString *headerStr = nil;
    switch (section) {
        case 0:
            break;
        case 1:
            headerStr = @"聊天群组";
            break;
        default:
            headerStr = [self.indexArray objectAtIndex:section - 2];
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

@end
