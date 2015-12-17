//
//  LTBaseChatViewController.m
//  RCS
//
//  Created by zyq on 15/10/26.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTBaseChatViewController.h"
#import "LTInputView.h"
#import "LTAttachToolBarView.h"
#import "LTMessageCell.h"
#import "LTMessageModel.h"
#import "LTMessageFrameModel.h"
#import "LTLinkVideoViewController.h"
#import "LTNavigationController.h"
#import "LTVoiceCallViewController.h"

@interface LTBaseChatViewController () <UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,
                                        UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property(nonatomic,strong) UIView *backgroundView;
@property(nonatomic,strong) UITableView *chatTableView;
@property(nonatomic,strong) LTInputView *inputView;
@property(nonatomic,strong) LTAttachToolBarView *attachToolBarView;

@property(nonatomic,strong) NSLayoutConstraint *inputViewHeightConstrains;
@property(nonatomic,strong) NSLayoutConstraint *backgroundViewBottomConstrains;

@property(nonatomic,strong) NSMutableArray *messagesArray;
@property(nonatomic,strong) NSDateFormatter *formatter;
@property(nonatomic,assign) CGFloat textViewConstant;
@property(nonatomic,strong) NSString *addMessage;
@end

@implementation LTBaseChatViewController

//取得聊天假数据
- (NSMutableArray *)messagesArray {
    if (!_messagesArray) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil]];
        NSMutableArray *messagesArrayM = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            LTMessageModel *messageModel = [LTMessageModel messageWithDic:dict];
            //取出上一个模型
            LTMessageFrameModel *lastFrameModel = [messagesArrayM lastObject];
            //隐藏时间一样的标签
            messageModel.hideMessageTime = [messageModel.messageTime isEqualToString:lastFrameModel.messageModel.messageTime];
            
            LTMessageFrameModel *frameModel = [[LTMessageFrameModel alloc]init];
            frameModel.messageModel = messageModel;
            [messagesArrayM addObject:frameModel];
        }
        _messagesArray = messagesArrayM;
    }
    return _messagesArray;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    }
    return _formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化视图
    [self setupView];
    
    self.textViewConstant = self.inputViewHeightConstrains.constant;
    
    //监听键盘动作通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化视图，添加约束
 */
- (void)setupView {
    //self.backgroundView.backgroundColor = RGB(245, 246, 249);
//    self.backgroundView = [[UIView alloc]init];
//    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:self.backgroundView];
    
    //创建聊天界面显示tableView
    self.chatTableView = [[UITableView alloc]init];
    self.chatTableView.translatesAutoresizingMaskIntoConstraints = NO;
    //禁止cell选中
    self.chatTableView.allowsSelection = NO;
    self.chatTableView.backgroundColor = RGB(236, 235, 241);
    //隐藏分割线
    self.chatTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    [self.view addSubview:self.chatTableView];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    tap.numberOfTapsRequired = 1;
    [self.chatTableView addGestureRecognizer:tap];
    
    //创建输入视图
    self.inputView = [LTInputView inputView];
    self.inputView.translatesAutoresizingMaskIntoConstraints = NO;
    //设置文本输入框代理
    self.inputView.textInputView.delegate = self;
    //输入视图按钮监听事件
    [self.inputView.attachButton addTarget:self action:@selector(attachButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inputView];
    
    
    //创建约束
    //背景视图的约束
//    NSDictionary *views = @{@"backgroundView":self.backgroundView};
//    NSArray *backgroundViewHConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundView]-0-|" options:0 metrics:nil views:views];
//    [self.view addConstraints:backgroundViewHConstrains];
//    
//    NSArray *vBackgroundViewConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundView]-0-|" options:0 metrics:nil views:views];
//    [self.view addConstraints:vBackgroundViewConstrains];
//    self.backgroundViewBottomConstrains = [vBackgroundViewConstrains lastObject];
//    
    //子视图的约束
    //水平方向上的约束
    NSDictionary *subViews = @{@"chatTableView":self.chatTableView,
                            @"inputView":self.inputView};
    
    NSArray *chatTableViewHConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chatTableView]-0-|" options:0 metrics:nil views:subViews];
    [self.view addConstraints:chatTableViewHConstrains];
    
    NSArray *inputViewHConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:subViews];
    [self.view addConstraints:inputViewHConstrains];
    
    //添加垂直方向上的约束
    NSArray *vConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chatTableView]-0-[inputView(48)]-0-|" options:0 metrics:nil views:subViews];
    [self.view addConstraints:vConstrains];
    
    self.inputViewHeightConstrains = vConstrains[2];
    self.backgroundViewBottomConstrains = [vConstrains lastObject];
}

#pragma mark - inputView按钮点击事件

/**
 *  弹出附加功能选择视图
 */
- (void)attachButtonClick:(UIButton *)btn {
    //关闭键盘
    [self.view endEditing:YES];
    
    btn.selected = !btn.selected;
    
    if (btn.isSelected) {
        //创建视图
        self.attachToolBarView = [[LTAttachToolBarView alloc]init];
        self.attachToolBarView.frame = CGRectMake(0, SCREEN_HEIGTH, SCREEN_WIDTH, 65);
        CGRect rect = self.attachToolBarView.frame;
        [self.view addSubview:self.attachToolBarView];

        //点击选择图片
        [self.attachToolBarView.imagePickerButton addTarget:self
                                                     action:@selector(imagePickerButtonClick)
                                           forControlEvents:UIControlEventTouchUpInside];
        [self.attachToolBarView.videoTalkButton addTarget:self
                                                   action:@selector(videoTalkButtonClick)
                                         forControlEvents:UIControlEventTouchUpInside];
        [self.attachToolBarView.voiceTalkButton addTarget:self
                                                   action:@selector(voiceTalkButtonClick)
                                         forControlEvents:UIControlEventTouchUpInside];
        
        
        self.backgroundViewBottomConstrains.constant = 65;
        rect.origin.y = SCREEN_HEIGTH - 65 * 2;
      
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.attachToolBarView.frame = rect;
            [self.view layoutIfNeeded];
            [self scrollToTableViewBottom];
        } completion:nil];

    } else {
        //隐藏视图
        self.backgroundViewBottomConstrains.constant = 0;
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.view layoutIfNeeded];
            self.attachToolBarView.hidden = YES;
        } completion:nil];
    }
    
}

/**
 *  发送按钮点击事件
 */
- (void)sendButtonClick {

    if (self.addMessage == nil) {
        return;
    }
    
    [self addMessage:self.addMessage type:LTMessageModelTypeMe];
}

#pragma mark - 手势动作
- (void)singleTap {
    [self.view endEditing:YES];
}

#pragma mark - AttachToolBarView按钮点击事件
/**
 *  选择图片
 */
- (void)imagePickerButtonClick {
    if (IOS8) { //是iOS8及以上系统
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
     
        //判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //相机
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
            
            [alertController addAction:cameraAction];
        }
        
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //相册
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        //修改颜色
        [photoLibraryAction setValue:UIColorFromHexValue(0x2a2a2a) forKey:@"_titleTextColor"];
        [alertController addAction:photoLibraryAction];
        
        
        //取消
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //修改颜色
        [cancelAction setValue:UIColorFromHexValue(0x2a2a2a) forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
        
        //弹出视图
        [self presentViewController:alertController animated:YES completion:nil];
    } else { //iOS8以下系统
        UIActionSheet *actionSheet;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择",nil];
        } else {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册中选择", nil];
        }
        [actionSheet showInView:self.view];
    }
}

/**
 *  视频通话连接
 */
- (void)videoTalkButtonClick {
    LTLinkVideoViewController *linkVideoVC = [[LTLinkVideoViewController alloc]initWithNibName:@"LTLinkVideoViewController" bundle:nil];
    
    [self.navigationController pushViewController:linkVideoVC animated:YES];
}

/**
 *  对讲
 */
- (void)voiceTalkButtonClick {
    LTVoiceCallViewController *voiceCallVC = [[LTVoiceCallViewController alloc]initWithNibName:@"LTVoiceCallViewController" bundle:nil];
    [self.navigationController pushViewController:voiceCallVC animated:YES];
}

#pragma mark - 键盘动作通知
//键盘弹出
- (void)keyboardWillShow:(NSNotification *)notification {
    
    self.attachToolBarView.hidden = YES;
    
    CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardEndFrame.size.height;
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    self.backgroundViewBottomConstrains.constant = keyboardHeight;
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
        [self scrollToTableViewBottom];
    } completion:^(BOOL finished) {
        
    }];
}

//键盘收回
- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    self.backgroundViewBottomConstrains.constant = 0;
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITextView代理
/**
 *  当输入多行文字时，改变输入框的高度
 */
- (void)textViewDidChange:(UITextView *)textView {
    //获取textView的contentSize
    CGFloat contentHeight = self.inputView.textInputView.contentSize.height;
    
    //改变textView高度
    if (contentHeight > 33) {
         self.inputViewHeightConstrains.constant = contentHeight;
    }
    
    self.addMessage = textView.text;
    if ([self.addMessage rangeOfString:@"\n"].length != 0) {
        
        [self addMessage:self.addMessage type:LTMessageModelTypeMe];
        
    } else {
        return;
    }
}

/**
 *  新增一条消息数据
 *
 *  @param message 输入的消息内容
 *  @param type    消息的发送方
 */
- (void)addMessage:(NSString *)message type:(LTMessageModelType)type {
    
    //新增消息内容
    LTMessageModel *messageModel = [[LTMessageModel alloc]init];
    NSDate *nowDate = [NSDate date];
    NSString *messageTime = [self.formatter stringFromDate:nowDate];
    
    //去除换行字符
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    messageModel.messageTime = messageTime;
    messageModel.messageContentText = message;
    messageModel.messageType = type;
    
    //设置内容的frame
    LTMessageFrameModel *frameModel = [[LTMessageFrameModel alloc]init];
    frameModel.messageModel = messageModel;
    [self.messagesArray addObject:frameModel];
    
    //清空数据
    self.inputView.textInputView.text = @"";
    //恢复textView高度
    self.inputViewHeightConstrains.constant = self.textViewConstant;
    
    //刷新表格
    
    [self.chatTableView reloadData];
    [self scrollToTableViewBottom];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSUInteger sourceType = 0;
    
    
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 1://相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2://相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                break;
        }
    } else {
        if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    //跳转到相机或相册
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LTMessageCell *cell = [LTMessageCell messageCellWithTableView:tableView];
    LTMessageFrameModel *frameModel = self.messagesArray[indexPath.row];
    cell.messageFrame = frameModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTMessageFrameModel *frameModel = self.messagesArray[indexPath.row];
    return frameModel.cellHeight;
}

#pragma mark - 其它
//tableView滚动的时候收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];

}

/**
 *  滚动到chatTableView底部
 */
- (void)scrollToTableViewBottom {
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollToTableViewBottom];
}

/**
 *  取消通知订阅
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
