//
//  LTBaiduMapViewController.m
//  RCS
//
//  Created by zyq on 15/11/2.
//  Copyright (c) 2015年 BGXT. All rights reserved.
//

#import "LTBaiduMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface LTBaiduMapViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic,weak) BMKMapView *mapView;
@property (nonatomic,weak) BMKLocationService *locService;
@end

@implementation LTBaiduMapViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [_mapView viewWillAppear];
//    _mapView.delegate = self;
//    _locService.delegate = self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图";
    
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    mapView.delegate = self;
    mapView.scrollEnabled = YES;
    
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    BMKLocationService *locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    self.locService = locService;
//    
//    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
//    annotation.coordinate = coor;
//    annotation.title = @"这里是北京";
//    [self.mapView addAnnotation:annotation];
    
    //进入普通定位状态
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO; //先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow; //设置定位的状态
    self.mapView.showsUserLocation = YES; //显示定位图层
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    LTLog(@"annotation:%@",annotation);
    if ([annotation isKindOfClass:[BMKAnnotationView class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;
        return newAnnotationView;
    }
    return nil;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    LTLog(@"userLocation:%@",userLocation);
    [self.mapView updateLocationData:userLocation];
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
@end
