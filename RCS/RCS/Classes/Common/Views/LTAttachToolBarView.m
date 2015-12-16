//
//  LTAttachToolBarView.m
//  RCS
//
//  Created by zyq on 15/10/26.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTAttachToolBarView.h"

#define BUTTON_WIDTH 45
#define BUTTON_MARGIN_LEFT 15
#define BUTTON_MARGIN_RIGHT 15
#define BUTTON_MARGIN_TOP 10

@implementation LTAttachToolBarView


- (instancetype)init {
    if (self == [super init]) {
        
        self.backgroundColor = RGB(240 , 240, 240);
        
        CGFloat padding = (SCREEN_WIDTH - BUTTON_WIDTH * 4 - BUTTON_MARGIN_LEFT - BUTTON_MARGIN_RIGHT) / 3;
        
        _imagePickerButton = [[UIButton alloc]init];
        _imagePickerButton.frame = CGRectMake(BUTTON_MARGIN_LEFT, BUTTON_MARGIN_TOP, BUTTON_WIDTH, BUTTON_WIDTH);
        [_imagePickerButton setImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
        [self addSubview:_imagePickerButton];
        
        _filePickerButton = [[UIButton alloc]init];
        _filePickerButton.frame = CGRectMake(CGRectGetMaxX(_imagePickerButton.frame) + padding, BUTTON_MARGIN_TOP, BUTTON_WIDTH, BUTTON_WIDTH);
        [_filePickerButton setImage:[UIImage imageNamed:@"add_file"] forState:UIControlStateNormal];
        [self addSubview:_filePickerButton];
        
        _videoTalkButton = [[UIButton alloc]init];
        _videoTalkButton.frame = CGRectMake(CGRectGetMaxX(_filePickerButton.frame) + padding, BUTTON_MARGIN_TOP, BUTTON_WIDTH, BUTTON_WIDTH);
        [_videoTalkButton setImage:[UIImage imageNamed:@"add_shipin"] forState:UIControlStateNormal];
        [self addSubview:_videoTalkButton];
        
        _voiceTalkButton = [[UIButton alloc]init];
        _voiceTalkButton.frame = CGRectMake(CGRectGetMaxX(_videoTalkButton.frame) + padding, BUTTON_MARGIN_TOP, BUTTON_WIDTH, BUTTON_WIDTH);
        [_voiceTalkButton setImage:[UIImage imageNamed:@"add_duijiang"] forState:UIControlStateNormal];
        [self addSubview:_voiceTalkButton];
    }
    return self;
}



@end
