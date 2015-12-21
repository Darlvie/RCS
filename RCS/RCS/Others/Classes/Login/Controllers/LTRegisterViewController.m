//
//  LTRegisterViewController.m
//  RCS
//
//  Created by aUser on 12/16/15.
//  Copyright © 2015 BGXT. All rights reserved.
//

#import "LTRegisterViewController.h"
#import "UIView+Toast.h"
#import "LTRegisterManager.h"
#import "NSString+NTES.h"
#import "SVProgressHUD.h"

@interface LTRegisterViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewConstraint;

@property (nonatomic,assign) CGFloat constant;
@end

@implementation LTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureLabelAndButton];
    
    [self configureNavi];
    
    [self resetTextField:self.usernameTextField];
    [self resetTextField:self.nicknameTextField];
    [self resetTextField:self.passwordTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.constant = self.inputViewConstraint.constant;
    self.registerButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Private
- (void)configureLabelAndButton {
    //设置login按钮样式
    self.registerButton.layer.borderWidth = 1.0;
    self.registerButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.registerButton.layer.cornerRadius = 3.0;
    self.registerButton.layer.masksToBounds = YES;
    
    //设置textField
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    self.nicknameTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
}

- (void)configureNavi {
    UIImage *backImage = [UIImage imageNamed:@"icon_back_normal.png"];
    [self.navigationController.navigationBar setBackIndicatorImage:backImage];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:backImage];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationController.navigationBar setTintColor:UIColorFromHexValue(0xffffff)];
    self.navigationItem.backBarButtonItem = backItem;
    
    //设置LOGO
    NSShadow *titleShadow = [[NSShadow alloc] init];
    titleShadow.shadowColor = RGBA(0, 0, 0, 0.8);
    titleShadow.shadowOffset = CGSizeMake(0, 1);
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"Miti"
                                                                 attributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(245, 245, 245),NSForegroundColorAttributeName,titleShadow,NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:35.0],NSFontAttributeName, nil]];
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [logoLabel setTextAlignment:NSTextAlignmentCenter];
    logoLabel.attributedText = attStr;
    self.navigationItem.titleView = logoLabel;
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)resetTextField:(UITextField *)testField {
    testField.tintColor = [UIColor whiteColor];
    [testField setValue:UIColorFromRGBA(0xffffff, 0.6f) forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *clearButton = [testField valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"login_icon_clear"] forState:UIControlStateNormal];
}

- (void)onRegister:(id)sender {
    LTRegisterData *data = [[LTRegisterData alloc] init];
    data.username = self.usernameTextField.text;
    data.token = [self.passwordTextField.text tokenByPassword];    
    data.nickname = self.nicknameTextField.text;
    
    if (![self check]) {
        return;
    }
    
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[LTRegisterManager sharedManager] registerUser:data completion:^(NSError *error, NSString *errorMsg) {
        [SVProgressHUD dismiss];
        
        if (error == nil) {
            [weakSelf.navigationController.view makeToast:@"注册成功！"
                                                 duration:2
                                                 position:CSToastPositionCenter];
            if ([weakSelf.deleagte respondsToSelector:@selector(registerDidComplete:password:)]) {
                [weakSelf.deleagte registerDidComplete:data.username password:self.passwordTextField.text];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            if ([weakSelf.deleagte respondsToSelector:@selector(registerDidComplete:password:)]) {
                [weakSelf.deleagte registerDidComplete:nil password:nil];
            }
            NSString *toast = @"注册失败";
            if ([errorMsg isKindOfClass:[NSString class]] && errorMsg.length) {
                toast = [toast stringByAppendingFormat:@": %@",errorMsg];
            }
            [weakSelf.view makeToast:toast
                            duration:2
                            position:CSToastPositionCenter];
        }
    }];
}

- (BOOL)check {
    if (![self checkUsername]) {
        [self.view makeToast:@"账号长度有误！"
                    duration:2
                    position:CSToastPositionCenter];
        return NO;
    }
    
    if (![self checkNickname]) {
        [self.view makeToast:@"昵称长度有误！"
                    duration:2
                    position:CSToastPositionCenter];
        return NO;
    }
    if (![self checkPassword]) {
        [self.view makeToast:@"密码长度有误！"
                    duration:2
                    position:CSToastPositionCenter];
        return NO;
    }
    
    return YES;
}

- (BOOL)checkUsername {
    NSString *username = self.usernameTextField.text;
    return username.length > 0 && username.length <= 10;
}

- (BOOL)checkNickname {
    NSString *nickname = self.nicknameTextField.text;
    return nickname.length > 0 && nickname.length <= 10;
}

- (BOOL)checkPassword {
    NSString *password = self.passwordTextField.text;
    return password.length > 0 && password.length <= 10;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Actions
- (IBAction)onChanged:(id)sender {
    BOOL enabled = [_usernameTextField.text length] && [_nicknameTextField.text length] && [_passwordTextField.text length];
    [self.registerButton setEnabled:enabled];
}

- (IBAction)registerButtonClick:(id)sender {
    
    [self onRegister:sender];
    
}

- (IBAction)backLoginButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self onRegister:nil];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.usernameTextField resignFirstResponder];
        [self.nicknameTextField becomeFirstResponder];
    } else if (textField == self.nicknameTextField) {
        [self.nicknameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.passwordTextField resignFirstResponder];
    }
    self.registerButton.enabled = YES;
    return YES;
}

@end
