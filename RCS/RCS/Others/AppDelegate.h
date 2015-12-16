//
//  AppDelegate.h
//  RCS
//
//  Created by zyq on 15/10/22.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) UINavigationController *navigationController;
@property(nonatomic,strong) BMKMapManager *mapManager;

@end

