//
//  PayCenterViewController.h
//  P-SHARE
//
//  Created by fay on 16/9/2.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseViewController.h"
#pragma mark ---------------------订单类型-----------------------------
//订单类型：10预约停车，11临停，12代泊，13月租，14产权，15加油卡,16钱包,17洗车
typedef enum:NSInteger {
    PayCenterViewControllerOrferTypeYuYue       = 10,
    PayCenterViewControllerOrferTypeLinTing     = 11,
    PayCenterViewControllerOrferTypeDaiBo       = 12,
    PayCenterViewControllerOrferTypeYueZu       = 13,
    PayCenterViewControllerOrferTypeChanQuan    = 14,
    PayCenterViewControllerOrferTypeJiaYouKa    = 15,
    PayCenterViewControllerOrferTypeQianBao     = 16,
    PayCenterViewControllerOrferTypeXiChe       = 17,

}PayCenterViewControllerOrderType;


typedef enum:NSInteger {
    PayCenterViewControllerPayKindWallet = 0,
    PayCenterViewControllerPayKindWechat,
    PayCenterViewControllerPayKindAlipay,
}PayCenterViewControllerPayKind;
@interface PayCenterViewController : BaseViewController

/**
 *  orderKind:  NSInteger订单类型
 *  
 */
@property (nonatomic,assign)PayCenterViewControllerOrderType orderKind;

//---------------------预约停车订单-----------------------------
/**
 *  预约时间
 */
@property (nonatomic,copy)NSString *appointmentDate;
/**
 *  套餐ID
 */
@property (nonatomic,copy)NSString *packageId;
//---------------------预约停车订单-----------------------------

/**
 *  订单
 */
@property (nonatomic,strong) OrderModel *order;
/**
 *  判断是否有订单  no：第一次创建订单 yes：从订单中心进入，继续支付
 */
@property (nonatomic,assign)BOOL    hasOrder;

@end


