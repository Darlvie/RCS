//
//  LTInputView.m
//  RCS
//
//  Created by zyq on 15/10/26.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTInputView.h"

@implementation LTInputView

- (void)awakeFromNib {
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.masksToBounds = YES;
    self.textInputView.layer.borderWidth = 0.5;
    self.textInputView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.textInputView.layer.masksToBounds = YES;
}

+ (instancetype)inputView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"LTInputView" owner:nil options:nil] lastObject];
}


@end
