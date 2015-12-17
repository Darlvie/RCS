//
//  LTVoiceCallViewController.m
//  RCS
//
//  Created by zyq on 15/10/29.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTVoiceCallViewController.h"

@interface LTVoiceCallViewController ()

@end

@implementation LTVoiceCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"对讲中";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"exit_btn"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(exitVoiceCall)];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitVoiceCall {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
