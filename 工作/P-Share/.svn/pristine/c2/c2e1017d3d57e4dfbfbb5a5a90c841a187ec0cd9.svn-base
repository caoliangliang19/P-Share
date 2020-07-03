//
//  GroupManage.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User,Parking,Car,OrderModel,CoordinateModel,YuYueTimeModel;
/**
 *  全局单例，保存一些全局数据：user、car、parking......
 */
typedef enum {
    NetworkStatusUnKnow = 0,
    NetworkStatusWifi,
    NetworkStatusWWAN,
    NetworkStatusNotReachable
}NetworkStatus;
@interface GroupManage : NSObject
/**
 *  用户信息
 */
@property (nonatomic,strong)User            *user;
/**
 *  用户选择的停车场
 */
@property (nonatomic,strong)Parking         *parking;
/**
 *   用户设置家停车场
 */
@property (nonatomic,strong)Parking         *homeParking;
/**
 *   用户设置车生活停车场
 */
@property (nonatomic,strong)Parking         *carLiftParking;
/**
 *  用户选择的车辆
 */
@property (nonatomic,strong)Car             *car;
/**
 *  用户支付订单
 */
@property (nonatomic,strong)OrderModel       *order;
/**
 *  用户当前坐标
 */
@property (nonatomic,strong)CoordinateModel *coordinateModel;
/**
 *  是否是游客 yes:是 no:不是
 */
@property (nonatomic,assign)BOOL            isVisitor;
/**
 *   用户预约套餐
 */
@property (nonatomic,strong)YuYueTimeModel *yuYueTimeModel;
/**
 *  网络状态
 */
@property (nonatomic,assign)NetworkStatus   networkStatus;
/**
 *  登录类型
 */
@property (nonatomic,copy)NSString          *loginType;
/**
 *  登录类型
 */
@property (nonatomic,copy)NSString          *qiyuId;
/**
 *  第三方登录表示 快捷登录10 微信01 微博03 qq04
 */
@property (nonatomic,copy)NSString          *openid;
/**
 *  第三方用户头像
 */
@property (nonatomic,copy)NSString          *headimgurl;
/**
 *  第三方用户昵称
 */
@property (nonatomic,copy)NSString          *nickname;

/**
 *  MBProgressHUD
 */
@property (nonatomic,strong)MBProgressHUD   *hub;

/**
 *  grayView
 */
@property (nonatomic,strong)UIView          *grayView;

/**
 *  MBProgressHUD
 */
@property (nonatomic,strong)MBProgressHUD   *alertHud;
/**
 *  微信回调地址
 */
@property (nonatomic,copy)NSString          *wechatCallBackURL;
/**
 *  支付宝回调地址
 */
@property (nonatomic,copy)NSString          *alipayCallBackURL;


+ (instancetype)shareGroupManages;
/**
 *  展示hub
 */
- (void)groupHubShow;
/**
 *  隐藏hub
 */
- (void)groupHubHidden;
/**
 *  展示提示语
 *
 *  @param title 提示语
 */
- (void)groupAlertShowWithTitle:(NSString *)title;

@end
