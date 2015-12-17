//
//  LTLoginViewController.m
//  RCS
//
//  Created by zyq on 15/10/29.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTLoginViewController.h"
#import "LTUnderlineTextField.h"
#import "Masonry.h"
#import "MBProgressHUD+BWMExtension.h"
#import "LTAnimatedImagesView.h"
#import "LTNavigationController.h"
#import "LTSlideMenuViewController.h"
#import "LTChatListViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

#define USER_NAME @"userName"
#define PASSWORD @"password"

@interface LTLoginViewController () <UITextFieldDelegate,LTAnimatedImagesViewDelegate>

@property(nonatomic,strong) UIView *inputView;
@property(nonatomic,strong) LTAnimatedImagesView *animatedImagesView;
@property(nonatomic,strong) LTUnderlineTextField *userNameTextField;
@property(nonatomic,strong) LTUnderlineTextField *passwordTextField;
@property(nonatomic,strong) UIButton *loginButton;
@property(nonatomic,assign) CGRect viewFrame;
@property(nonatomic,strong) UILabel *logoLabel;

@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation LTLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.animatedImagesView startAnimating];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewFrame = self.view.frame;
    
    //初始化视图
    [self setupView];
    
    //设置视图约束
    [self setupConstraint];
    
    //订阅键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.animatedImagesView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    
    //添加动态图
    self.animatedImagesView = [[LTAnimatedImagesView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.animatedImagesView];
    self.animatedImagesView.delegate = self;
    
    //添加logo标签
    _logoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _logoLabel.backgroundColor = [UIColor clearColor];
    _logoLabel.text = @"米提讯通";
    _logoLabel.textColor = [UIColor whiteColor];
    _logoLabel.textAlignment = NSTextAlignmentCenter;
    [_logoLabel setFont:[UIFont fontWithName:@"Heiti SC" size:25.f]];
    [self.view addSubview:_logoLabel];
    
    //添加中部输入视图
    _inputView = [[UIView alloc]initWithFrame:CGRectZero];
    _inputView.userInteractionEnabled = YES;
    [self.view addSubview:_inputView];
    
    //用户名输入框
    _userNameTextField = [[LTUnderlineTextField alloc]initWithFrame:CGRectZero];
    _userNameTextField.backgroundColor = [UIColor clearColor];
    _userNameTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"用户" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _userNameTextField.textColor = [UIColor whiteColor];
    _userNameTextField.delegate = self;
    _userNameTextField.text = [USERDEFAULT objectForKey:USER_NAME];
    if (_userNameTextField.text.length > 0) {
        [_userNameTextField setFont:[UIFont fontWithName:@"Heiti SC" size:25.f]];
    }
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.adjustsFontSizeToFitWidth = YES;
    [_userNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventValueChanged];
    [_inputView addSubview:_userNameTextField];
    
    //密码输入框
    _passwordTextField = [[LTUnderlineTextField alloc]initWithFrame:CGRectZero];
    _passwordTextField.backgroundColor = [UIColor clearColor];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _passwordTextField.textColor = [UIColor whiteColor];
    _passwordTextField.text = [USERDEFAULT objectForKey:PASSWORD];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_inputView addSubview:_passwordTextField];
    
    //登录按钮
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
    _loginButton.imageView.contentMode = UIViewContentModeCenter;
    [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:_loginButton];
}

/**
 *  设置视图约束
 */
- (void)setupConstraint {
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(80);
        make.left.equalTo(self.view.mas_left).with.offset(41);
        make.right.equalTo(self.view.mas_right).with.offset(-41);
        make.height.equalTo(@60);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoLabel.mas_bottom).with.offset(40);
        make.left.equalTo(self.view.mas_left).with.offset(41);
        make.right.equalTo(self.view.mas_right).with.offset(-41);
        make.height.equalTo(@180);
    }];
    
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_top);
        make.left.equalTo(self.inputView.mas_left);
        make.right.equalTo(self.inputView.mas_right);
        make.height.equalTo(@60);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom);
        make.left.equalTo(self.inputView.mas_left);
        make.right.equalTo(self.inputView.mas_right);
        make.height.equalTo(@60);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom);
        make.left.equalTo(self.inputView.mas_left);
        make.right.equalTo(self.inputView.mas_right);
        make.height.equalTo(@44);
    }];
}

//用户名输入时改变字体大小
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length == 0) {
        [textField setFont:[UIFont fontWithName:@"Heiti SC" size:18.0]];
    }
    else {
        [textField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
    }
}

/**
 *  登录按钮点击事件
 */
- (void)loginButtonClick {
    if ([self.userNameTextField.text  isEqualToString:@""] || [self.passwordTextField.text  isEqualToString:@""]) {
        [MBProgressHUD bwm_showTitle:@"用户名或密码不能为空" toView:self.view hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeWarning];
    } else if ([self.userNameTextField.text isEqualToString:@"admin"] && [self.passwordTextField.text isEqualToString:@"123456"]) {
        [USERDEFAULT setObject:@"admin" forKey:USER_NAME];
        [USERDEFAULT setObject:@"123456" forKey:PASSWORD];
        [MBProgressHUD bwm_showTitle:@"登录成功！" toView:self.view hideAfter:1.5 msgType:BWMMBProgressHUDMsgTypeSuccessful];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loginSuccess];
        });
        
    } else{
        [MBProgressHUD bwm_showTitle:@"用户名或密码错误" toView:self.view hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
    }
}

//验证用户名密码成功后跳转
- (void)loginSuccess {
    
    LTChatListViewController *chatVC = [[LTChatListViewController alloc]init];
    LTNavigationController *navi = [[LTNavigationController alloc]initWithRootViewController:chatVC];
    LTSlideMenuViewController *slideMenuVC = [[LTSlideMenuViewController alloc]init];
    
    //添加主控制器和侧边栏菜单控制器
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:navi leftDrawerViewController:slideMenuVC];
    
    //设置阴影效果
    [self.drawerController setShowsShadow:YES];
    
    //设置动画效果
    [self.drawerController setMaximumLeftDrawerWidth:240 animated:YES completion:nil];
    [self.drawerController setShouldStretchDrawer:NO];
    
    //所有视图都能打开侧边栏菜单
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //设置视觉效果
    [self.drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        if (block) {
            block(drawerController,drawerSide,percentVisible);
        }
    }];
    
    [self presentViewController:self.drawerController animated:YES completion:nil];
}

#pragma mark - 键盘事件监听
//键盘抬起时上移输入视图
- (void)keyboardWillShow:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue];    
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        self.view.frame = CGRectMake(0, -50, self.view.bounds.size.width, self.view.bounds.size.height);

    } completion:nil];
}

//键盘收回时下移输入视图
- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);;
        
    } completion:nil];

}

//点击空白界面收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self.userNameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

//修改状态栏风格
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - LTAnimatedImagesViewDelegate
- (NSUInteger)animatedImagesNumberOfImages:(LTAnimatedImagesView*)animatedImagesView
{
    return 2;
}

- (UIImage*)animatedImagesView:(LTAnimatedImagesView*)animatedImagesView imageAtIndex:(NSUInteger)index
{
    return [UIImage imageNamed:@"login_background.jpg"];
}

//移除通知订阅
- (void)dealloc {
    [self setAnimatedImagesView:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
