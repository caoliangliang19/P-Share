//
//  MapView.m
//  GaoDeMap_fay
//
//  Created by fay on 16/6/13.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "MapView.h"
#import "CoordinateModel.h"
#import "CommonUtility.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
const NSInteger RoutePlanningPaddingEdge                    = 20;
@interface MapView()<MAMapViewDelegate,AMapSearchDelegate>
{
    AMapSearchAPI *_search;
    NSArray *_pathPolylines;
    
}
/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;
@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic,strong)  MAMapView *mapview;
@end

@implementation MapView

@synthesize startCoordinate         = _startCoordinate;
@synthesize destinationCoordinate   = _destinationCoordinate;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self insertSubview:self.mapview atIndex:0];

    }
    
    return self;
}


- (void)setModel:(CoordinateModel *)model
{
    _model = model;
//    self.startCoordinate        = CLLocationCoordinate2DMake(model.startOneCoordinate,model.endOneCoordinate);
//    self.destinationCoordinate  = CLLocationCoordinate2DMake(model.startTwoCoordinate, model.endTwoCoordinate);

    
    [self addDefaultAnnotations];
    [self searchRoutePlanningDrive];
}


- (MAMapView *)mapview
{
    if (!_mapview) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _mapview = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, size.width, 250)];
        [self addSubview:_mapview];
        _mapview.delegate = self;
        _mapview.showsCompass = NO;
        _mapview.showsScale = NO;
        _mapview.zoomEnabled = NO;
        _mapview.scrollEnabled = NO;
        _mapview.rotateEnabled = NO;
        _mapview.rotateCameraEnabled = NO;
        _mapview.skyModelEnable = NO;
        
        [_mapview mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            
        }];
        _search = [[AMapSearchAPI alloc] init];

    }
    return _mapview;
    
}

- (void)addDefaultAnnotations
{
    [_mapview removeAnnotations:_mapview.annotations];
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [_mapview addAnnotation:startAnnotation];
    [_mapview addAnnotation:destinationAnnotation];
}
/* 驾车路径规划搜索. */
- (void)searchRoutePlanningDrive
{
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    _search.delegate = self;
    [_search AMapDrivingRouteSearch:navi];
}

#pragma mark - AMapSearchDelegate

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    self.route = response.route;
    self.currentCourse = 0;
    
    if (response.count > 0)
    {
        //移除地图原本的遮盖
        [_mapview removeOverlays:_pathPolylines];
        _pathPolylines = nil;
        
        // 只显⽰示第⼀条 规划的路径
        _pathPolylines = [CommonUtility polylinesForPath:response.route.paths[0]];
        
        NSLog(@"%@",response.route.paths[0]);
        //添加新的遮盖，然后会触发代理方法进行绘制
        [_mapview addOverlays:_pathPolylines];
        [_mapview setVisibleMapRect:[CommonUtility mapRectForOverlays:_pathPolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
    }
    
}


#pragma mark - MAMapViewDelegate
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    
    //画路线
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //初始化一个路线类型的view
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        //设置线宽颜色等
        polygonView.lineWidth = 8.f;
        //设置是否为虚线
        polygonView.lineDash = YES;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        //返回view，就进行了添加
        return polygonView;
    }
    return nil;
    
}
#pragma mark -- 添加起点、重点大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[_mapview dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        /* 起点. */
        if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
        }
        /* 终点. */
        else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
        }

        return poiAnnotationView;
    }
    
    return nil;
}




@end
