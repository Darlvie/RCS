//
//  LTNavigationController.m
//  RCS
//
//  Created by zyq on 15/10/22.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTNavigationController.h"
#import "UIViewController+MMDrawerController.h"

@interface LTNavigationController ()

@end

@implementation LTNavigationController

+ (void)initialize {
    //设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    //设置普通状态下的样式
    NSMutableDictionary *textAttrs= [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    
    //设置导航栏背景
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"top_bg"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:textAttrs];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 *  重写导航控制器push方法
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //这时push进来的控制器不是根控制器
        //自定义返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_btn"]
                                                                                          style:UIBarButtonItemStyleDone
                                                                                         target:self
                                                                                         action:@selector(back)];
        
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chat_people"]
                                                                                           style:UIBarButtonItemStyleDone
                                                                                          target:self
                                                                                          action:@selector(gotoRootController)];
    }
    [super pushViewController:viewController animated:YES];
}

/**
 *  点击返回上级控制器
 */
- (void)back {
    
    [self popViewControllerAnimated:YES];
}

/**
 *  点击返回根控制器
 */
- (void)gotoRootController {
    [self popToRootViewControllerAnimated:YES];
}

/**
 *  设置状态栏风格
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleLightContent;
    }
}
@end
