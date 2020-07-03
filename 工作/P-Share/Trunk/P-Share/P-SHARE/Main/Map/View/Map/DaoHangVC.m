//
//  faySheetVC.m
//  P-Share
//
//  Created by fay on 16/1/13.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "DaoHangVC.h"
#import <MapKit/MapKit.h>
#import <JZLocationConverter.h>
#import <CoreLocation/CoreLocation.h>
@interface DaoHangVC ()<UIActionSheetDelegate,CLLocationManagerDelegate>
{
    UIAlertView         *_alert;
    CLLocationManager   *_cllManager;
    CGFloat             _myLatitude;
    CGFloat             _myLongitude;
    NSInteger           _repeat;

}
@property (nonatomic,copy) NSString *modelLatitude;
@property (nonatomic,copy) NSString *modelLongitude;
@property (nonatomic,copy) NSString *modelParkingName;
@end

@implementation DaoHangVC
- (instancetype)initWithParking:(Parking*)parking
{
    if (self = [super init]) {
        _modelParkingName = parking.parkingName;
        _modelLatitude = parking.parkingLatitude;
        _modelLongitude = parking.parkingLongitude;
        [self getLocationAndPushAndMob];
    }
    return self;
}

- (void)getLocationAndPushAndMob
{
    _repeat = 1;
    _cllManager = [[CLLocationManager alloc] init];
    _cllManager.distanceFilter = kCLDistanceFilterNone;
    _cllManager.desiredAccuracy = kCLLocationAccuracyBest;
    _cllManager.delegate = self;
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [_cllManager requestWhenInUseAuthorization];
    }
    [_cllManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    _myLatitude = location.coordinate.latitude;
    _myLongitude = location.coordinate.longitude;
    
    
    MyLog(@"location----%@",location);
    
//    保存用户坐标到单例
    CoordinateModel *model = [GroupManage shareGroupManages].coordinateModel;
    model.longitude = _myLongitude;
    model.latitude = _myLatitude;
    if (_repeat == 1) {
        UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图",@"百度地图",@"高德地图", nil];
        [shareSheet showInView:self.view];
        _repeat = 2;
    }else{
        return;
    }
    
    [_cllManager stopUpdatingLocation];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:{
            //自带地图导航
            CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(_myLatitude, _myLongitude);
            CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake([self.modelLatitude floatValue], [self.modelLongitude floatValue]);
            CLLocationCoordinate2D offsetCoord = [JZLocationConverter gcj02ToWgs84:coord2];
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord1 addressDictionary:nil]];
            currentLocation.name = @"当前位置";
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:offsetCoord addressDictionary:nil]];
            toLocation.name = self.modelParkingName;
            NSArray *items = [NSArray arrayWithObjects:currentLocation,toLocation, nil];
            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
            [MKMapItem openMapsWithItems:items launchOptions:options];
        }
            break;
        case 1:{
            //百度地图导航
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
            {
                CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(_myLatitude, _myLongitude);
                CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake([self.modelLatitude floatValue], [self.modelLongitude floatValue]);
                CLLocationCoordinate2D offsetCoord1 = [JZLocationConverter wgs84ToBd09:coord1];
                CLLocationCoordinate2D offsetCoord2 = [JZLocationConverter gcj02ToBd09:coord2];
                NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:自己的位置&destination=latlng:%f,%f|name:%@&mode=driving",offsetCoord1.latitude,offsetCoord1.longitude,offsetCoord2.latitude, offsetCoord2.longitude, self.modelParkingName];
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }else{

                [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"您未安装高德地图或版本不支持"];

            }
        }
            break;
        case 2:{
            //高德地图导航  067c1d2281fc7f9141e3725058c9e240
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
                
                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=wx0112a93a0974d61b&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=0",@"口袋停",self.modelParkingName, [self.modelLatitude floatValue], [self.modelLongitude floatValue]];
                
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }else{

                [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"您未安装高德地图或版本不支持"];
            }
        }
            break;
        default:
            break;
    }
    [self.view removeFromSuperview];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
