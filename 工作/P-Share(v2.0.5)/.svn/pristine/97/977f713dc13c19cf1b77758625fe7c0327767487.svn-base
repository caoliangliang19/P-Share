//
//  DaiBoInfoV.h
//  P-Share
//
//  Created by fay on 16/6/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DaiBoInfoVStatusNoCheWei,           //没有车位
    DaiBoInfoVStatusGetOrder,           //接单成功
    DaiBoInfoVStatusShowCarPhoto,       //展示车辆照片
    DaiBoInfoVStatusParking,            //停车中
    DaiBoInfoVStatusParkEnd,            //停车完成
    DaiBoInfoVStatusSaveKey,            //存钥匙
    DaiBoInfoVStatusTimeNotification,   //时间提醒
    DaiBoInfoVStatusGetCaring,          //取车中
    DaiBoInfoVStatusGetCarEnd,          //取车完成

    DaiBoInfoVStatusHomeNoCheWei,       //家停车场没有车位


}DaiBoInfoVStatus;
@interface DaiBoInfoV : UIView
@property (nonatomic,assign)DaiBoInfoVStatus    status;
@property (nonatomic,strong)ParkingModel        *dataModel;
@property (nonatomic,strong)UIView              *containV;
@property (nonatomic,strong)TemParkingListModel *temModel;
@property (nonatomic,assign)BOOL isHomePark;
@property (nonatomic,strong)UILabel             *topL;//上方label

@property (nonatomic,copy)void (^statusCompleteBlock)(DaiBoInfoV *daiBoInfoV);

@end
