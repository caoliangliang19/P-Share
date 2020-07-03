//
//  YuYueView.h
//  P-Share
//
//  Created by fay on 16/6/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    YuYueViewStatusNoOrder,             //没有订单
    YuYueViewStatusSuccess,             //预约成功
    YuYueViewStatusCarInPark,           //车辆入场
    YuYueViewStatusTimeNotification,    //时间提醒
    YuYueViewStatusEnd,                  //服务结束
    
     YuYueViewStatusNoParking,          //没有车位  状态变为可导航
    
}YuYueViewStatus;
@interface YuYueView : UIView
@property (nonatomic,strong)ParkingModel    *dataModel;
@property (nonatomic,assign)YuYueViewStatus status;

@property (nonatomic,strong)UIView          *containV;
@property (nonatomic,strong)UILabel         *bottomRightL;

@property (nonatomic,copy)void (^statusCompleteBlock)(YuYueView *yuYueView);
@property (nonatomic,strong)TemParkingListModel *temModel;
@property (nonatomic,copy)  NSString                    *distance;

@end
