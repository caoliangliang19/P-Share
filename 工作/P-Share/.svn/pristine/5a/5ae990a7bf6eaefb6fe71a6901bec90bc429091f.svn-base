//
//  FayAnnotationView.h
//  GaoDeMap_fay
//
//  Created by fay on 16/6/12.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
typedef enum{
//    导航
    CalloutViewStyleDaoHang,//CalloutViewStyleNormal
//    代泊
    CalloutViewStyleDaiBo,//CalloutViewStyleNervous
//    临停
    CalloutViewStyleLinTing,//CalloutViewStylesZiYuan
    
}CalloutViewStyle;
@interface FayAnnotationView : MAAnnotationView
+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;

@property (nonatomic, assign) CalloutViewStyle calloutViewStyle;

@property (nonatomic, copy) void (^goToParkDetail)( Parking *);

//只为保存原parkingModel
@property (nonatomic,strong)Parking *originalModel;

@property (nonatomic,strong)Parking *parkModel;

@property (nonatomic,strong)NSString *annotationID;

@property (nonatomic,assign)BOOL isHomePark;

@property (nonatomic,assign)BOOL needAnimation;


@end
