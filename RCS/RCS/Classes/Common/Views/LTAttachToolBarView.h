//
//  LTAttachToolBarView.h
//  RCS
//
//  Created by zyq on 15/10/26.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTAttachToolBarView : UIView
/** 照片选择 */
@property(nonatomic,strong) UIButton *imagePickerButton;
/** 文件选择 */
@property(nonatomic,strong) UIButton *filePickerButton;
/** 视频聊天 */
@property(nonatomic,strong) UIButton *videoTalkButton;
/** 语音聊天 */
@property(nonatomic,strong) UIButton *voiceTalkButton;

@end
