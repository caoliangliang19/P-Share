//
//  NetWorkInterface.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  网络接口在此处定义
 */
@interface NetWorkInterface : NSObject

/**
 *  错误提示
 */
UIKIT_EXTERN NSString *const SERVERERROR;
UIKIT_EXTERN NSString *const NETWORKINGERROE;



UIKIT_EXTERN NSString *const VERSION;
UIKIT_EXTERN NSString *const ERROR_INFO;
UIKIT_EXTERN NSString *const ERROR_NUM;
UIKIT_EXTERN NSString *const SYSUSER_ID;
UIKIT_EXTERN NSString *const USER_NAME;


#pragma mark --- 接口
/**
 *  测试URL
 */
UIKIT_EXTERN NSString *const KDEBUG_SERVER_URL;

/**
 *  生产URL
 */
UIKIT_EXTERN NSString *const KRELEASE_SERVER_URL;


/**
 *  正在使用的URL
 */
UIKIT_EXTERN NSString *const SERVER_URL;

/**
 *  拼接URL
 */
#define APP_URL(url)    [NSString stringWithFormat:@"%@%@",SERVER_URL,url]


/**
 *  位置搜索车场
 */
UIKIT_EXTERN NSString *const searchParkListByLL;
/**
 *  提交调查预约问券
 */
UIKIT_EXTERN NSString *const questionnairec;
/**
 * //取消预约调查问券
 */
UIKIT_EXTERN NSString *const questionnairelist;
/**
 *  获取停车场信息
 */
UIKIT_EXTERN NSString *const getParkingStatus;
/**
 *  获取临停缴费列表（临停缴费首页）
 */
UIKIT_EXTERN NSString *const temporarycarlist;
/**
 *  获取月租产权接口（月租产权首页）
 */
UIKIT_EXTERN NSString *const getMonthlyEquity;
/**
 *  查询车位紧张接口
 */
UIKIT_EXTERN NSString *const tenseTime;
/**
 *  查看订单
 */
UIKIT_EXTERN NSString *const queryParkerById;
/**
 *  地图判断周边是否有停车场
 */
UIKIT_EXTERN NSString *const getIsParking;
/**
 *  预约凭证列表
 */
UIKIT_EXTERN NSString *const queryVoucherPage;
/**
 *  注册获取验证码
 */
UIKIT_EXTERN NSString *const sendSmsCode;
/**
 *  验证码登录
 */
UIKIT_EXTERN NSString *const loginByVerifyCode;
/**
 *  获取家停车场
 */
UIKIT_EXTERN NSString *const indexShow;
/**
 *  获取预约停车上方时间
 */
UIKIT_EXTERN NSString *const reservedParking;
/**
 *  选择日期获取改日期下的套餐
 */
UIKIT_EXTERN NSString *const choseWeek;

/**
 *  创建临停订单
 */
UIKIT_EXTERN NSString *const orderc;
/**
 *  查看收藏
 */
UIKIT_EXTERN NSString *const queryCollection;
/**
 *  点击取消收藏
 */
UIKIT_EXTERN NSString *const deleteCollection;
/**
 *  点击收藏
 */
UIKIT_EXTERN NSString *const saveCollection;
/**
 *  所有停车场
 */
UIKIT_EXTERN NSString *const cusFindAllParking;
/**
 *  设置首页停车场
 */
UIKIT_EXTERN NSString *const setDefaultScan;
/**
 *  爱车生活查询车辆列表
 */
UIKIT_EXTERN NSString *const parkinglist;
/**
 *  爱车生活查询车辆列表
 */
UIKIT_EXTERN NSString *const gaindefaultcar;
/**
 *  设置默认车辆
 */
UIKIT_EXTERN NSString *const defaultcar;
/**
 *  新车型选择
 */
UIKIT_EXTERN NSString *const gaincarbrand;
/**
 *  获取厂家和车系列表
 */
UIKIT_EXTERN NSString *const gaincartrade;
/**
 *  获取排量和年款列表
 */
UIKIT_EXTERN NSString *const gaincardisplacement;
/**
 *  添加车辆
 */
UIKIT_EXTERN NSString *const bindingcar;
/**
 *  添加车辆详情
 */
UIKIT_EXTERN NSString *const gainbindingcar;
/**
 *  第三方快捷登录
 */
UIKIT_EXTERN NSString *const loginByOtherV2;
/**
 *  手机账号和微信绑定
 */
UIKIT_EXTERN NSString *const bondByOtherV2;
/**
 *  上传第三方信息
 */
UIKIT_EXTERN NSString *const updateCustomerInfo;
/**
 *  上传第三方信息
 */
UIKIT_EXTERN NSString *const deleteCar;
/**
 *  提交评论
 */
UIKIT_EXTERN NSString *const CommitApp;
/**
 *  优惠劵列表
 */
UIKIT_EXTERN NSString *const getCouponList;
/**
 *  爱车生活接口 1优惠停车 2用车心得
 */
UIKIT_EXTERN NSString *const queryActivity;
/**
 *  获取保养提醒信息列表
 */
UIKIT_EXTERN NSString *const gainupkeep;
/**
 *  获取七鱼ID
 */
UIKIT_EXTERN NSString *const getQiyuId;
/**
 *  修改行驶里程信息
 */
UIKIT_EXTERN NSString *const modtravlleddistance;
/**
 *  查询爱车生活车厂
 */
UIKIT_EXTERN NSString *const getParkingList;
/**
 *  获取车厂微信群二维码
 */
UIKIT_EXTERN NSString *const getCarlovQRCode;
/**
 *  获取停车场列表
 */
UIKIT_EXTERN NSString *const getParking;







#pragma mark --  AppKey
/**
 *  高德地图key
 */
UIKIT_EXTERN NSString *const GAODE_APPKEY;
/**
 *  微信key
 */
UIKIT_EXTERN NSString *const WECHAT_APPKEY;
/**
 *  QQkey
 */
UIKIT_EXTERN NSString *const QQ_APPKEY;

/**
 *  秘钥
 */
UIKIT_EXTERN NSString *const SECRET_KEY;

/**
 *  月租
 */
UIKIT_EXTERN NSString *const KMONTHLY;
/**
 *  产权
 */
UIKIT_EXTERN NSString *const KEQUITY;
/**
 *  临停
 */
UIKIT_EXTERN NSString *const KLINTING;
/**
 *  全部订单接口
 */
UIKIT_EXTERN NSString *const queryAllOrder;
/**
 *  取消订单接口
 */
UIKIT_EXTERN NSString *const cancelOrder;
/**
 *  订单详情接口
 */
UIKIT_EXTERN NSString *const orderDetail;
/**
 *  充值记录列表
 */
UIKIT_EXTERN NSString *const rechargelist;
/**
 *  消费记录列表
 */
UIKIT_EXTERN NSString *const consumlist;
/**
 *  钱包充值
 */
UIKIT_EXTERN NSString *const getMoney;
/**
 *  钱包充值规则
 */
UIKIT_EXTERN NSString *const getRult;
/**
 * 查询赠送金额的接口
 */
UIKIT_EXTERN NSString *const calcGiftAmount;
/**
 * 支付成功改变订单状态
 */
UIKIT_EXTERN NSString *const PAID;
/**
 * 获取发票信息
 */
UIKIT_EXTERN NSString *const getLatestInvoiceInfo;
/**
 * 提交发票
 */
UIKIT_EXTERN NSString *const postInvoiceInfo;
/**
 * 订单和优惠券绑定
 */
UIKIT_EXTERN NSString *const reqpay;
/**
 * 钱包支付
 */
UIKIT_EXTERN NSString *const walletPay;
/**
 * 支付成功修改订单状态
 */
UIKIT_EXTERN NSString *const paidOrder;
/**
 * 修改优惠券信息（支付失败或支付页不支付返回）
 */
UIKIT_EXTERN NSString *const cancel;
/**
 * 个人中心首页
 */
UIKIT_EXTERN NSString *const Info;
/**
 * 支付成功修改订单状态
 */
UIKIT_EXTERN NSString *const paid;
/**
 * 获取订单详情
 */
UIKIT_EXTERN NSString *const orderdetail;
/**
 * 评论
 */
UIKIT_EXTERN NSString *const submit;
/**
 * 查看评论
 */
UIKIT_EXTERN NSString *const queryByOrderId;
/**
 * 查看评论
 */
UIKIT_EXTERN NSString *const receiveCoupon;
/**
 * 上传头像
 */
UIKIT_EXTERN NSString *const updateImage;
/**
 * 修改上路时间信息
 */
UIKIT_EXTERN NSString *const modcanusedate;
/**
 * 首屏推广接口
 */
UIKIT_EXTERN NSString *const adverList;
/**
 * 使用优惠券 post（新接口）
 */
UIKIT_EXTERN NSString *const useCoupon;
/**
 * 代泊算法接口
 */
UIKIT_EXTERN NSString *const calcParkPrice;
/**
 * 查看订单详情
 */
UIKIT_EXTERN NSString *const queryOrderDetail;
/**
 * 代泊取车
 */
UIKIT_EXTERN NSString *const gettingCar;

/**
 * 预约 临停订单列表
 */
UIKIT_EXTERN NSString *const orderlist;
/**
 * 代泊订单列表
 */
UIKIT_EXTERN NSString *const queryFinishParkOrder;
/**
 * 钱包提交手机号
 */
UIKIT_EXTERN NSString *const validatecode;
/**
 * 钱包修改密码
 */
UIKIT_EXTERN NSString *const resetPayPassword;
/**
 * 提交验证码
 */
UIKIT_EXTERN NSString *const parkingvalidatecode;

@end
