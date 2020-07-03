//
//  TimeLineView.h
//  P-Share
//
//  Created by fay on 16/6/16.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    TimeLineViewPayTypeDaiBo,           //代泊时间轴
    TimeLineViewPayTypeYuYueParking     //预约时间轴
}TimeLineViewPayType;

typedef enum {
    TimeLineViewStyleOneLine,           //只有一行label
    TimeLineViewStyleTwoLine,           //有两行label
    TimeLineViewStyleTwoLineAndImage,   //两行带有图片
}TimeLineViewStyle;

typedef enum {
    TimeLineDaiBoSatusGetOrder,         //接单成功
    TimeLineDaiBoSatusYanChe,           //代泊远验车(带图片)
    TimeLineDaiBoSatusGoTopark,         //代泊员前往停车场
    TimeLineDaiBoSatusParkSuccess,      //车辆存放成功(带图片)
    TimeLineDaiBoSatusSaveKey,          //钥匙存入密码箱
    TimeLineDaiBoSatusTimeWillEnd,      //车位服务时间即将结束
//    TimeLineDaiBoSatusPayMoney,         //支付代泊费用
//    TimeLineDaiBoSatusGetCarOrderSuccess,//取车派单成功
    TimeLineDaiBoSatusGetCaring,        //代泊远取车中
//    TimeLineDaiBoSatusGetCarSuccess,    //车辆到达指定位置
    TimeLineDaiBoSatusEnd               //代泊服务结束 (立即评价)
    
}TimeLineDaiBoSatus;

typedef enum {
    TimeLineYuYueSatusStart,//开始预约
    TimeLineYuYueSatusYuYueSuccess,//预约成功
    TimeLineYuYueSatusPingZhengInPark,//凭证入场
    TimeLineYuYueSatusTimeWillEnd,//时间即将结束
    TimeLineYuYueSatusPingZhengOutPark,//凭证出场
    TimeLineYuYueSatusEnd//服务结束 (立即评价)
}TimeLineYuYueSatus;
@interface TimeLineView : UIView
//
///**
// *  排版类型
// */
@property (nonatomic,assign)TimeLineViewStyle   timeLineStyle;

/**
 *  时间轴类型(代泊、预约)
 */
@property (nonatomic,assign)TimeLineViewPayType timeLinePayStyle;

/**
 *  代泊状态
 */
@property (nonatomic,assign)TimeLineDaiBoSatus  timeLineDaiBoSatus;

/**
 *  预约状态
 */
@property (nonatomic,assign)TimeLineYuYueSatus  timeLineYuYueSatus;
- (instancetype)init;
@property (nonatomic,assign)TemParkingListModel *dataModel;//数据模型

@property (nonatomic,strong)UIImageView         *bgImageV;
@property (nonatomic,copy)NSString *timeString;
@property (nonatomic,copy)NSString *daiBoPerson;
@property (nonatomic,copy)NSArray *imageArray;
@property (nonatomic,copy)NSString *phone;

@property (nonatomic,strong)NSString            *parkCode;




@end
