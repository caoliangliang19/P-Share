//
//  DaiBoInfoV.h
//  P-Share
//
//  Created by fay on 16/6/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DaiBoInfoVStatusNervous,            //车位紧张
    DaiBoInfoVStatusGetOrder,           //接单成功
    DaiBoInfoVStatusShowCarPhoto,       //展示车辆照片
    DaiBoInfoVStatusParking,            //停车中
    DaiBoInfoVStatusParkEnd,            //停车完成
    DaiBoInfoVStatusSaveKey,            //存钥匙
    DaiBoInfoVStatusTimeNotification,   //时间提醒
    DaiBoInfoVStatusGetCaring,          //取车中
    DaiBoInfoVStatusGetCarEnd,          //取车完成
    DaiBoInfoVStatusHomeNervous,        //家停车场车位紧张


}DaiBoInfoVStatus;
@interface DaiBoInfoV : UIView
@property (nonatomic,assign)DaiBoInfoVStatus    status;
@property (nonatomic,strong)Parking             *dataModel;
@property (nonatomic,strong)UIView              *containV;
@property (nonatomic,strong)OrderModel          *temModel;
/**
 预计紧张时间
 */
@property (nonatomic,copy)NSString              *tenseTime;
@property (nonatomic,assign)BOOL isHomePark;
@property (nonatomic,strong)UILabel             *topL;//上方label

@property (nonatomic,copy)void (^statusCompleteBlock)(DaiBoInfoV *daiBoInfoV);

@end
