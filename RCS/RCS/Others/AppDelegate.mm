//
//  AppDelegate.m
//  RCS
//
//  Created by zyq on 15/10/22.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "AppDelegate.h"
#import "LTLoginViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 要使用百度地图，请先启动BaiduMapManager
    self.mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.mapManager start:@"cgmDPkG3hhIqmKIyq9qCL6gZ" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
//    
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
//    
//    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    LTLoginViewController *loginVC = [[LTLoginViewController alloc]init];
    [self.window setRootViewController:loginVC];
  
    [self.window setTintColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //当应用即将后台时调用，停止一切调用opengl相关的操作
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
