//
//  LTLoginController.m
//  RCS
//
//  Created by zyq on 15/12/16.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTLoginController.h"
#import "LTRegisterViewController.h"
#import "LTNavigationController.h"
#import "UIImage+NTESColor.h"
#import "LTRegisterViewController.h"
#import "SVProgressHUD.h"
#import "NSString+NTES.h"
#import "LTLoginManager.h"
#import "UIView+Toast.h"
#import "NTESService.h"
#import "LTChatListViewController.h"
#import "MMDrawerController.h"
#import "LTSlideMenuViewController.h"
#import "MMDrawerVisualState.h"
#import "NIMSDK.h"

@interface LTLoginController () <UITextFieldDelegate,LTRegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewConstraint;

@property (nonatomic,assign) CGFloat constant;
@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation LTLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureLabelAndButton];
    
    [self configureNavi];
    
    [self resetTextField:self.usernameTextField];
    [self resetTextField:self.passwordTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    self.constant = self.inputViewConstraint.constant;
    self.loginButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    
    [self configureStatusBar];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue];
    
    self.inputViewConstraint.constant = keyboardFrame.size.height;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue];

    self.inputViewConstraint.constant = self.constant;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)textFieldDidChange:(NSNotification *)notification {
    
}

#pragma mark - Private
- (void)configureLabelAndButton {
    //设置LOGO
    NSShadow *titleShadow = [[NSShadow alloc] init];
    titleShadow.shadowColor = RGBA(0, 0, 0, 0.8);
    titleShadow.shadowOffset = CGSizeMake(0, 1);
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"Miti"
                                                                 attributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(245, 245, 245),NSForegroundColorAttributeName,titleShadow,NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:50.0],NSFontAttributeName, nil]];
    self.titleLabel.attributedText = attStr;
    
    //设置login按钮样式
    self.loginButton.layer.borderWidth = 1.0;
    self.loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.loginButton.layer.cornerRadius = 3.0;
    self.loginButton.layer.masksToBounds = YES;
    
    //设置textField
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)configureStatusBar {
    UIStatusBarStyle style = [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
}

- (void)configureNavi {
    UIImage *clearImage = [UIImage clearColorImage];
    self.navigationItem.title = @"";
    [self.navigationController.navigationBar setBackgroundImage:clearImage
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:clearImage];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)resetTextField:(UITextField *)testField {
    testField.tintColor = [UIColor whiteColor];
    [testField setValue:UIColorFromRGBA(0xffffff, 0.6f) forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *clearButton = [testField valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"login_icon_clear"] forState:UIControlStateNormal];
}

- (void)doLogin {
    [self.view endEditing:YES];
    
    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.passwordTextField.text;
    [SVProgressHUD show];
    
    NSString *loginAccount = username;
    NSString *loginToken =  [password tokenByPassword];
    
    [[[NIMSDK sharedSDK] loginManager] login:loginAccount
                                       token:loginToken
                                  completion:^(NSError *error) {
                                      [SVProgressHUD dismiss];
                                      if (!error) {
                                          LTLoginData *sdkData = [[LTLoginData alloc] init];
                                          sdkData.username = loginAccount;
                                          sdkData.token = loginToken;
                                          [[LTLoginManager sdkManager] setCurrentLoginData:sdkData];
                                          
                                          LTLoginData *appData = [[LTLoginData alloc] init];
                                          appData.username = loginAccount;
                                          appData.token = loginToken;
                                          [[LTLoginManager appManager] setCurrentLoginData:appData];
                                          
                                          [[NTESServiceManager sharedManager] start];
                                          [self loginSuccess];
                                      } else {
                                          NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
                                          [self.view makeToast:toast duration:2 position:CSToastPositionCenter];
                                      }
                                  }];
}

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


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self doLogin];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.usernameTextField.text length] && [self.passwordTextField.text length]) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.passwordTextField resignFirstResponder];
    }
    self.loginButton.enabled = YES;
    return YES;
}

#pragma mark - Action

- (IBAction)loginButtonClick:(id)sender {
    [self doLogin];
}

- (IBAction)registerButtonClick:(id)sender {
    LTRegisterViewController *registerVC = [[LTRegisterViewController alloc]
                                            initWithNibName:@"LTRegisterViewController" bundle:nil];
    registerVC.deleagte = self;
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

#pragma mark - LTRegisterViewControllerDelegate
- (void)registerDidComplete:(NSString *)username password:(NSString *)password {
    if (username.length) {
        self.usernameTextField.text = username;
        self.passwordTextField.text = password;
        self.loginButton.enabled = YES;
    }
}









@end
