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
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface LTBaiduMapViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) CLLocation *location;
@property (nonatomic,strong) BMKGeoCodeSearch *geoSearch;
@end

@implementation LTBaiduMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(exitMapView)];
    
    BMKLocationService *locService = [[BMKLocationService alloc]init];
    self.locService = locService;
    //定位精度 100米
    self.locService.distanceFilter = 100;
    
    self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.scrollEnabled = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.zoomEnabledWithTap = YES;
    self.mapView.zoomLevel = 16;
    [self.view addSubview:self.mapView];
    
    self.geoSearch = [[BMKGeoCodeSearch alloc]init];
    
    //进入普通定位状态
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO; //先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow; //设置定位的状态
    self.mapView.showsUserLocation = YES; //显示定位图层
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.locService.delegate = self;
    self.mapView.delegate = self;
    self.geoSearch.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
}

//退出当前视图
- (void)exitMapView {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    DebugLogInfo(@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    NSDictionary *dict = BMKConvertBaiduCoorFrom(userLocation.location.coordinate, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D coordinate2D = BMKCoorDictionaryDecode(dict);
    //坐标转换
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
    BMKUserLocation *newLocation = [[BMKUserLocation alloc] init];
    [newLocation setValue:location forKey:@"location"];
    [self.mapView updateLocationData:newLocation];
    
    //设置地图显示区域
    BMKCoordinateRegion region;
    region.center.latitude = coordinate2D.latitude;
    region.center.longitude = coordinate2D.longitude;
    region.span = (BMKCoordinateSpan){0.01f,0.01f};
    region = [self.mapView regionThatFits:region];
    
    [self.mapView setRegion:region animated:YES];
    
}


#pragma mark - BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    //坐标转换
    NSDictionary *dict = BMKConvertBaiduCoorFrom(coordinate, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D coordinate2D = BMKCoorDictionaryDecode(dict);
    //反地理编码
    BMKReverseGeoCodeOption *geoOption = [[BMKReverseGeoCodeOption alloc]init];
    geoOption.reverseGeoPoint = coordinate2D;
    [self.geoSearch reverseGeoCode:geoOption];

}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    //移除之前的所有大头针
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:self.mapView.overlays];
    [self.mapView removeOverlays:array];
    
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [self.mapView addAnnotation:item];
        self.mapView.centerCoordinate = result.location;
    } else {
        DebugLogError(@"%d",error);
    }
}


/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    DebugLogError(@"location error");
}


@end
