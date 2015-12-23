//
//  LTUserInfoSettingViewController.m
//  RCS
//
//  Created by zyq on 15/12/22.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <NIMSDK.h>
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import "LTUserInfoSettingViewController.h"
#import "LTCommonTableDelegate.h"
#import "LTCommonTableData.h"
#import "NTESUserUtil.h"
#import "UIActionSheet+NTESBlock.h"
#import "LTNickNameSettingViewController.h"
#import "LTGenderSettingViewController.h"
#import "LTBirthSettingViewController.h"
#import "LTMobileSettingViewController.h"
#import "LTEmailSettingViewController.h"
#import "LTSignSettingViewController.h"
#import "UIImage+NTES.h"
#import "NTESFileLocationHelper.h"
#import <NIMWebImageManager.h>

@interface LTUserInfoSettingViewController () <NIMUserManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) LTCommonTableDelegate *delegator;
@property (nonatomic,copy) NSArray *data;
@end

@implementation LTUserInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人信息";
    [self buildData];
    __weak typeof(self) weakSelf = self;
    self.delegator = [[LTCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return weakSelf.data;
    }];
    self.tableView.delegate = self.delegator;
    self.tableView.dataSource = self.delegator;
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)dealloc {
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildData {
    NIMUser *me = [[NIMSDK sharedSDK].userManager userInfo:[[NIMSDK sharedSDK].loginManager currentAccount]];
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : me.userId ? me.userId : [NSNull null],
                                      CellClass     : @"NTESSettingPortraitCell",
                                      RowHeight     : @(100),
                                      CellAction    : @"onTouchPortrait:",
                                      ShowAccessory : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title      :@"昵称",
                                      DetailTitle:me.userInfo.nickName.length ? me.userInfo.nickName : @"未设置",
                                      CellAction :@"onTouchNickSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES),
                                      },
                                  @{
                                      Title      :@"性别",
                                      DetailTitle:[NTESUserUtil genderString:me.userInfo.gender],
                                      CellAction :@"onTouchGenderSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  @{
                                      Title      :@"生日",
                                      DetailTitle:me.userInfo.birth.length ? me.userInfo.birth : @"未设置",
                                      CellAction :@"onTouchBirthSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  @{
                                      Title      :@"手机",
                                      DetailTitle:me.userInfo.mobile.length ? me.userInfo.mobile : @"未设置",
                                      CellAction :@"onTouchTelSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  @{
                                      Title      :@"邮箱",
                                      DetailTitle:me.userInfo.email.length ? me.userInfo.email : @"未设置",
                                      CellAction :@"onTouchEmailSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  @{
                                      Title      :@"签名",
                                      DetailTitle:me.userInfo.sign.length ? me.userInfo.sign : @"未设置",
                                      CellAction :@"onTouchSignSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      ];
    
    self.data = [LTCommonTableSection sectionsWithData:data];
}

- (void)refresh {
    [self buildData];
    [self.tableView reloadData];
}

- (void)onTouchPortrait:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置头像"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍照",@"从相册", nil];
        [sheet showInView:self.view completionHandler:^(NSInteger index) {
            switch (index) {
                case 0:
                    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                    break;
                case 1:
                    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                default:
                    break;
            }
        }];
    } else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置头像"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"从相册", nil];
        [sheet showInView:self.view completionHandler:^(NSInteger index) {
            switch (index) {
                case 0:
                    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                    
                default:
                    break;
            }
        }];
    }
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = type;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)onTouchNickSetting:(id)sender{
    LTNickNameSettingViewController *vc = [[LTNickNameSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchGenderSetting:(id)sender{
    LTGenderSettingViewController *vc = [[LTGenderSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchBirthSetting:(id)sender{
    LTBirthSettingViewController *vc = [[LTBirthSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchTelSetting:(id)sender{
    LTMobileSettingViewController *vc = [[LTMobileSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchEmailSetting:(id)sender{
    LTEmailSettingViewController *vc = [[LTEmailSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchSignSetting:(id)sender{
    LTSignSettingViewController *vc = [[LTSignSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NIMUserManagerDelegate
- (void)onUserInfoChanged:(NIMUser *)user {
    if ([user.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        [self refresh];
    }
}

#pragma mark - Private
- (void)uploadImage:(UIImage *)image {
    UIImage *imageForAvatarUpload = [image imageForAvatarUpload];
    NSString *fileName = [NTESFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
    NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 1.0);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    __weak typeof(self) weakSelf = self;
    if (success) {
        [SVProgressHUD show];
        [[NIMSDK sharedSDK].resourceManager upload:filePath
                                          progress:nil
                                        completion:^(NSString *urlString, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error && weakSelf) {
                [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):urlString}
                                                      completion:^(NSError *error) {
                    if (!error) {
                        [[NIMWebImageManager sharedManager] saveImageToCache:imageForAvatarUpload
                                                                      forURL:[NSURL URLWithString:urlString]];
                        [weakSelf refresh];
                    } else  {
                        [weakSelf.view makeToast:@"设置头像失败,请重试"
                                        duration:2.0
                                        position:CSToastPositionCenter];
                    }
                }];
            } else {
                [weakSelf.view makeToast:@"图片上传失败，请重试"
                                duration:2.0
                                position:CSToastPositionCenter];
            }
        }];
    } else {
        [weakSelf.view makeToast:@"图片保存失败，请重试"
                        duration:2.0
                        position:CSToastPositionCenter];
    }
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}




























@end
