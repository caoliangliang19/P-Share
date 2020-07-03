//
//  CenterAnnotationView.h
//  P-SHARE
//
//  Created by fay on 2016/12/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CenterAnnotationView : MAAnnotationView
+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView;

- (void)showCalloutView;

- (void)hiddenCalloutView;

@property (nonatomic,getter=isCalloutShow)BOOL calloutShow;

@property (nonatomic,strong)UIImage *annotationImage;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *subTitle;

@property (nonatomic,strong)UIView *calloutView;

@property (nonatomic,assign)BOOL needBeat;

@end
