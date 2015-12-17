//
//  LTInputView.h
//  RCS
//
//  Created by zyq on 15/10/26.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTInputView : UIView
/** 录音按钮 */
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
/** 附加功能按钮 */
@property (weak, nonatomic) IBOutlet UIButton *attachButton;
/** 文本输入框 */
@property (weak, nonatomic) IBOutlet UITextView *textInputView;
/** 发送按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

+ (instancetype)inputView;
@end
