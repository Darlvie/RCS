//
//  LTLinkVideoViewController.m
//  RCS
//
//  Created by zyq on 15/10/29.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTLinkVideoViewController.h"
#import "UIImage+LTRoundIcon.h"

@interface LTLinkVideoViewController ()

@end

@implementation LTLinkVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频中";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"exit_btn"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(exitVideo)];
    
    self.avatarImageView.image = [UIImage imageWithIconName:@"avatar01.jpeg" border:0 borderColor:nil scale:1];
    self.exitButton.layer.cornerRadius = 5;
    self.exitButton.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitVideo {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
