//
//  NetworkTooler.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/25.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>
//139.196.48.108测试(废弃)

//http://139.196.24.16测试139.196.24.16
//139.196.12.103正式www.p-share.com



//预发布地址＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
#define  YUFABUURL                  [NSString stringWithFormat:@"http://%@/share/",SERVER_ID]


#define  YUFABU_TEST(p)             [NSString stringWithFormat:@"%@%@",YUFABUURL,p]

#define  CARMASTER_IMG              YUFABU_TEST(@"app/carlife/eventpage/list")

#define  CARMASTER_SERVERINFO       YUFABU_TEST(@"app/carlife/srvinfo/intro")

//获取我的默认爱车
#define  gaindefaultcar             YUFABU_TEST(@"app/carsteward/livecar/gaindefaultcar")

//获取保养提醒信息列表
#define  gainupkeep                 YUFABU_TEST(@"app/carsteward/livecar/gainupkeep")

//修改上路时间信息
#define  modcanusedate              YUFABU_TEST(@"app/carsteward/livecar/modcanusedate")

//修改行驶里程信息
#define  modtravlleddistance        YUFABU_TEST(@"app/carsteward/livecar/modtravlleddistance")

//获取排量和年款列表
#define  gaincardisplacement        YUFABU_TEST(@"app/carsteward/livecar/gaincardisplacement")


//新车型选择 get
#define  gaincarbrand               YUFABU_TEST(@"app/carsteward/livecar/gaincarbrand")

//获取厂家和车系列表 get
#define  gaincartrade               YUFABU_TEST(@"app/carsteward/livecar/gaincartrade")

//获取车厂微信群二维码
#define  getCarlovQRCode            YUFABU_TEST(@"app/parking/carLov/getCarlovQRCode")

// 爱车生活接口
#define  queryActivity              YUFABU_TEST(@"app/carLifeActivity/queryActivity")

// 查询车位紧张接口
#define  tenseTime                  YUFABU_TEST(@"app/parking/tenseTime")

// 查看订单详情
#define  queryOrderDetail           YUFABU_TEST(@"app/order/queryOrderDetail")

// 验证码登录
#define  loginByVerifyCode          YUFABU_TEST(@"app/customer/loginByVerifyCode")

// 查看评价
#define  queryByOrderId             YUFABU_TEST(@"app/comment/queryByOrderId")

// 评论提交接口
#define  submit                     YUFABU_TEST(@"app/comment/submit")

//首屏推广接口
#define  adverList                  YUFABU_TEST(@"app/advertising/adverList")

//代泊取车
#define  gettingCar                 YUFABU_TEST(@"app/parker/gettingCar")

//查看代泊订单
#define  indexShow                  YUFABU_TEST(@"app/parker/indexShow")

//获取首页信息
#define  queryParkerById            YUFABU_TEST(@"app/parker/queryParkerById")

//预约停车接口
#define  reservedParking            YUFABU_TEST(@"app/parking/reservedParking")

//选择日期获取改日期下的套餐
#define  choseWeek                  YUFABU_TEST(@"app/parking/choseWeek")

//创建代泊订单
#define  orderc                     YUFABU_TEST(@"app/order/orderc")

//设置首页停车场
#define  setDefaultScan             YUFABU_TEST(@"app/parker/setDefaultScan")

//是否满足代泊条件
#define  isCanPark                  YUFABU_TEST(@"/app/parker/isCanPark")

//代泊算法接口
#define  calcParkPrice              YUFABU_TEST(@"/app/parker/calcParkPrice")

//所有停车场
#define  cusFindAllParking          YUFABU_TEST(@"app/parker/cusFindAllParking")

//获取所有收藏车场
#define  searchParkingCollection    YUFABU_TEST(@"app/parker/searchParkingCollection")

//收藏车场
#define  saveParkingCollection      YUFABU_TEST(@"app/parker/saveParkingCollection")

//取消收藏
#define  cusCancelCollection        YUFABU_TEST(@"app/parker/cusCancelCollection")

//获取停车场
#define  getParking                 YUFABU_TEST(@"app/parker/getParking")

//查看订单
#define  queryParkerById            YUFABU_TEST(@"app/parker/queryParkerById")

//获取临停缴费列表（临停缴费首页）
#define  TemParkingOrderList        YUFABU_TEST(@"app/temporary/carlist")

//创建临停订单
#define  ORDERC                     YUFABU_TEST(@"app/order/orderc")

//临停订单与优惠券绑定
#define  REPAY                      YUFABU_TEST(@"app/order/reqpay")

//修改订单（支付成功）
#define  PAID                       YUFABU_TEST(@"app/order/paid")

//修改订单（支付成功）new
#define  paidOrder                  YUFABU_TEST(@"app/order/paidOrder")

//修改优惠券信息（支付失败或支付页不支付返回）
#define  CANCEL                     YUFABU_TEST(@"app/order/cancel")

//使用优惠券 post（新接口）
#define  USECOUPON                  YUFABU_TEST(@"app/order/useCoupon")

//获取停车场列表
#define  GETLIST                    YUFABU_TEST(@"app/parker/getParking")

//获取绑定车辆列表
#define  CARLIST                    YUFABU_TEST(@"app/parking/carlist")

//注册获取验证码
#define GETREGISTER_CODE            REGISTER(@"/sendSmsCode")

//提交验证码
#define  VALIDATECODE               YUFABU_TEST(@"app/parking/validatecode")

//获取单价
#define  GETPRICE                   YUFABU_TEST(@"app/parking/getprice")

//删除订单
//#define  DELEGATE                   YUFABU_TEST(@"app/order/delete")

//获取订单列表
#define  ORDERLIST                  YUFABU_TEST(@"app/order/orderlist")

//获取历史订单列表
#define  HISTORYORDERLIST           YUFABU_TEST(@"app/myaccount/orderlist")

//获取订单详情
#define  ORDERDETAIL                YUFABU_TEST(@"app/myaccount/orderdetail")

//版本更新相关
#define  UPDATE                     YUFABU_TEST(@"app/version/update")

//取消预约调查问券
#define  questionnairelist          YUFABU_TEST(@"app/parker/questionnairelist")

//提交调查预约问券
#define  questionnairec             YUFABU_TEST(@"app/parker/questionnairec")

//提交预约凭证
#define  addVoucher                 YUFABU_TEST(@"app/parking/addVoucher")


//预约凭证列表
#define  queryVoucherPage          YUFABU_TEST(@"app/customer/queryVoucherPage")

//地图判断周边是否有停车场
#define  getIsParking               YUFABU_TEST(@"app/parking/getIsParking")

//添加加油卡
#define   addOilCard              YUFABU_TEST(@"app/carlife/refuel/cardc")

//获取加油卡列表
#define   oilCardList           YUFABU_TEST(@"app/carlife/refuel/cardlist")

//订单列表
#define orderList              YUFABU_TEST(@"app/carlife/refuel/orderlist")

//检查第三方快捷登录
#define loginByOther           YUFABU_TEST(@"app/customer/loginByOtherV2")

//手机账号和微信绑定
#define registByOther          YUFABU_TEST(@"app/customer/bondByOtherV2")

//我的优惠券是否提示小红点
#define getCouponNum           YUFABU_TEST(@"app/coupon/getCouponNum")

//未付款已付款订单列表
#define monthlyEquityList      YUFABU_TEST(@"app/order/monthlyEquityList")

//取消订单
#define cancelOrder            YUFABU_TEST(@"app/order/cancelOrder")

//获取车管家服务信息
#define List                   YUFABU_TEST(@"app/carlife/srvinfo/list")

//租车接口
#define CarRentList            YUFABU_TEST(@"app/carlife/carRent/list/703bab4898801ae2b11353d8f8f9c722")

// 取得账户余额
#define getMoney               YUFABU_TEST(@"app/customer/getMoney")

// 充值规则
#define getRule                YUFABU_TEST(@"app/customer/getRule")

// 代泊钱包支付
#define payParking             YUFABU_TEST(@"app/order/payParking")

// 钱包支付
#define walletPay              YUFABU_TEST(@"app/order/walletPay")

//充值记录列表
#define rechargelist           YUFABU_TEST(@"app/order/rechargelist")

//消费记录列表
#define consumlist             YUFABU_TEST(@"app/order/consumlist")

//钱包提交手机号
#define validatecode           YUFABU_TEST(@"app/customer/validatecode")

//钱包修改密码
#define resetPayPassword       YUFABU_TEST(@"app/customer/resetPayPassword")

//查询月租产权代泊未付款订单（小红点）
#define selectCount            YUFABU_TEST(@"app/order/selectCount")

//查询优惠券小红点
#define queryRedDot            YUFABU_TEST(@"app/coupon/queryRedDot")

//用户浏览过后调用此接口清除小红点
#define closeRedDot            YUFABU_TEST(@"app/coupon/closeRedDot")

//用户登录
#define customlogin            YUFABU_TEST(@"app/customer/login")

//矫健验证码
#define verifySmsCode          YUFABU_TEST(@"app/customer/verifySmsCode")

//重置密码
#define resetPwd               YUFABU_TEST(@"app/customer/resetPwd")

//添加车辆
#define addCar                 YUFABU_TEST(@"app/myaccount/addCar")

//新查询车辆列表
#define NewCarList             YUFABU_TEST(@"app/carsteward/livecar/parkinglist")

//查询车辆是否开启自动支付
#define isAutoPay              YUFABU_TEST(@"app/car/isAutoPay")

//删除车辆 GET
#define delete                 YUFABU_TEST(@"app/car/delete")

//添加车辆 POST
#define addCheLiang            YUFABU_TEST(@"app/carsteward/livecar/bindingcar")

//查询赠送金额的接口
#define calcGiftAmount         YUFABU_TEST(@"app/order/calcGiftAmount")

//检测手机号
#define getPhoneCode           YUFABU_TEST(@"app/customer/getPhoneCode")

//提交发票
#define postInvoiceInfo        YUFABU_TEST(@"app/order/postInvoiceInfo")

//获取订单信息
#define getLatestInvoiceInfo   YUFABU_TEST(@"app/order/getLatestInvoiceInfo")

//获取优惠券列表
#define GETCOUPONLIST          YUFABU_TEST(@"app/coupon/getCouponList")

//生成洗车订单
#define  washCarOrderc         YUFABU_TEST(@"app/order/orderc")

//洗车规则
#define  queryCharge           YUFABU_TEST(@"app/carlife/queryCharge")

//洗车订单列表
#define carwashList            YUFABU_TEST(@"app/order/carwashList")


#define getRecursionCarModel   YUFABU_TEST(@"app/car/getRecursionCarModel")

//预约时间不能重复
#define queryAppointment       YUFABU_TEST(@"app/customer/queryAppointment")

//位置搜索车场
#define SEARCH_PARK_BY_LL      YUFABU_TEST(@"app/parker/searchParkListByLL")

//关键词搜索停车场
#define SEARCH_PARKLIST_BY_NAME     YUFABU_TEST(@"app/parker/searchParkListbyName")

//代泊订单列表
#define queryFinishParkOrder        YUFABU_TEST(@"app/parker/queryFinishParkOrder")

//代泊评论接口
#define commentc                    YUFABU_TEST(@"app/comment/commentc")

//加载洗车员头像
#define queryImage                  YUFABU_TEST(@"app/carlife/queryImage")

//查看收藏
#define queryCollection           YUFABU_TEST(@"app/customer/queryCollection")

//点击收藏
#define saveCollection            YUFABU_TEST(@"app/customer/saveCollection")

//点击取消收藏
#define deleteCollection          YUFABU_TEST(@"app/customer/deleteCollection")

//获取停车场信息
#define getParkingStatus          YUFABU_TEST(@"app/parking/getParkingStatus")

//  首页  根据车牌查询是否是月租产权接口
#define getMonthlyEquity          YUFABU_TEST(@"app/car/getMonthlyEquity")

//可以提供服务的车场
#define getParkingList          YUFABU_TEST(@"app/carlife/getParkingList")

//查询所有订单
#define queryAllOrder          YUFABU_TEST(@"app/order/queryAllOrder")
//查询爱车生活车厂
#define carParkingList          YUFABU_TEST(@"app/parking/carLov/getParkingList")

// 爱车生活接口 1优惠停车 2用车心得
#define queryActivity          YUFABU_TEST(@"app/carLifeActivity/queryActivity")

// 获取七鱼ID
#define getQiyuId          YUFABU_TEST(@"app/parking/carLov/getQiyuId")

// 获取七鱼ID
#define gainBindingCar          YUFABU_TEST(@"app/carsteward/livecar/gainbindingcar")
// 设置默认车辆
#define defaultcar          YUFABU_TEST(@"app/carsteward/livecar/defaultcar")

//停车场信息详情
#define parkingInfoDetail         YUFABU_TEST(@"app/customer/parkingInfoDetail")

//意见反馈
#define COMMITAPP                  YUFABU_TEST(@"app/customer/CommitApp")
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊



//接口定义
#define SERVER_KEY                  [NSString stringWithFormat:@"http://%@/ShanganParking/{2}/{1.3.1}/customer",SERVER_ID]//服务器地址
#define URL_MACRO(p)                [NSString stringWithFormat:@"%@%@",SERVER_KEY,p]
//获取验证码，注册接口
#define REGISTER(p)                 [NSString stringWithFormat:@"http://%@/share/app/customer%@",SERVER_ID,p]
//优惠劵
#define DISCOUNT(p)                 [NSString stringWithFormat:@"http://%@/share/app%@",SERVER_ID,p]
//获取首页家／公司停车场
#define GET_FIRSTPARKING            URL_MACRO(@"/indexShow")

//@"http://www.p-share.com/ShanganParking/1/1.0.0/customer/aliPayOrder"
//支付宝回调
#define ALIPAYORDER                 URL_MACRO(@"/aliPayOrder")

//  34dc21ba48c4a6956f8a81522821be81(new)  909110fd7305195902079f9e48057e42  c6fee5639b975105a49239106c9819ba
//聚合获取全国可以查询车辆违章的地区
#define JUHEURL                     @"http://v.juhe.cn/wz/citys?key=909110fd7305195902079f9e48057e42"
//兌换优惠劵
#define HAVEDISCOUNTCOUPON           DISCOUNT(@"/coupon/receiveCoupon")
//聚合查询全国车辆违章
#define JUHEREHULATIONSEARCH         @"http://v.juhe.cn/wz/query"

//聚合加油卡充值
//#define JUHEBUYOILCAR              @"http://v.juhe.cn/wz/query"

//优惠订单取消订单
#define CANCLESHAREOLDER             URL_MACRO(@"/cancelShareOrder")

//修改月租订单状态
#define UPDATEFEEOERDERINFO          URL_MACRO(@"/updateFeeOrderInfo")

//设置首页家／公司停车场
#define SET_FIRSTPARKING             URL_MACRO(@"/setDefaultScan")

//获取支付码
#define GET_PAYMENT_CODE             URL_MACRO(@"/addParkingCode")

//注册
#define USER_REGIST                  REGISTER(@"/register")

//获取验证码
#define GET_USER_CODE                URL_MACRO(@"/sendSmsCode")

//校验验证码
#define VERIFY_USER_CODE             URL_MACRO(@"/verifySmsCode")

//重置密码
#define RESET_PWD                    URL_MACRO(@"/resetPwd")

//登陆
#define USER_Login                   URL_MACRO(@"/login")

//获取基本信息
//#define GET_USER_INFO              URL_MACRO(@"/doctor/getInfo")

//设置基本信息---------post请求
#define SET_USER_INFO                URL_MACRO(@"/setUserInfo")

//注销
#define USER_LOG_OUT                 URL_MACRO(@"/logout")

//添加车辆
#define ADD_CAR_URL                  URL_MACRO(@"/addCar")

//获取车列表
#define GET_CAR_LIST                 URL_MACRO(@"/carList")

//获取车列表
#define DELETE_CAR                   URL_MACRO(@"/deleteCar")

//关键词搜索停车场
#define SEARCH_PARK_BY_NAME          URL_MACRO(@"/searchParkListbyName")

//位置搜索车场
#define SEARCH_PARK_BY11            URL_MACRO(@"/searchParkListByLL")

//位置搜索附近车场
#define SEARCH_PARK_BY_PAEK          URL_MACRO(@"/searchParkListByParking")

//发起预约
#define CREATE_ORDER                 URL_MACRO(@"/createOrder")

//取消预约
#define CANCEL_ORDER                 URL_MACRO(@"/cancelOrder")

//取车接口
#define GET_CAR                      URL_MACRO(@"/getCar")

//获取 总价
#define CALCULATE_PAY                URL_MACRO(@"/calculatePay")

//获取 月租单价
#define GET_UNIT_PRICE               URL_MACRO(@"/getunitprice")

//提交月租订单
#define POST_RENT_ORDER              URL_MACRO(@"/postorderinfo")

//请求月租历史列表
#define GET_HISRENT_ORDER            URL_MACRO(@"/searchRentAndPropertyParkingOrderById")

//请求当前月租订单
#define GET_RENT_ORDER               URL_MACRO(@"/getorderinfo")

//删除月租
#define DEL_RENT_ORDER               URL_MACRO(@"/delOrder")

//订单支付
#define PAY_ORDER                    URL_MACRO(@"/payOrder")

//评价订单
#define ORDER_COMMENT                URL_MACRO(@"/comment")

//查看预约中订单状态
#define STATE_FOR_ORDER              URL_MACRO(@"/unfinishedOrder")

//历史订单
#define HISTORY_ORDER                URL_MACRO(@"/searchHelpParkingOrderById")

//临停历史订单
#define TEM_HISTORY_ORDER            URL_MACRO(@"/searchTemptyOrderById")

//收藏停车场
#define SAVE_PARKER                  URL_MACRO(@"/saveParking")

//取消收藏停车场
#define CANCLE_PARKER                URL_MACRO(@"/cusCancelCollection")

//停车场详情调用
#define PARKINGDETAIL                URL_MACRO(@"/parkingInfoDetail")

//根据市区搜索车场接口
#define SEARCH_PARKLIST_BY_AREA      URL_MACRO(@"/searchParkListbyArea")

//根据市区搜索车场接口
#define SEARCH_PARKLIST_BY_NA11      URL_MACRO(@"/searchParkListbyName")

//拉停车场收藏清单
#define GET_PARDERLIST               URL_MACRO(@"/searchSaveParkList")

//根据车场ID返回车场详细信息
#define PARK_INFO_PARK_ID            URL_MACRO(@"/searchParkbyId")

//获取首页信息
#define INDEXSHOW                    URL_MACRO(@"/indexShow")

//获取首页消息
#define INDMESSAGE                   URL_MACRO(@"/indexMessage")

//设置首页车场
#define SETDEFAULTSCAN               URL_MACRO(@"/setDefaultScan")

//获取所有停车场
#define CUSFINDALLPARKING            URL_MACRO(@"/cusFindAllParking")



//获取临停订单
#define GETPARKLOTFEE                URL_MACRO(@"/getParklotFee")

//临停支付调用
#define PSSTTEMPORARY                URL_MACRO(@"/posttemporaryorderinfo")


//兑换优惠券
#define RECEIVEBYCDKEY               URL_MACRO(@"/receive")

//扫码兑换优惠券
#define REXEIVEBYVOUCHERS            URL_MACRO(@"/ReceiveCouponByVouchers")

//检查优惠券是否可用
#define COUPONISUES                  URL_MACRO(@"/checkCoupon")

//支付失败
#define PAYFAIL                      URL_MACRO(@"/payFail")

//取消支付
#define CANCELPARK                   URL_MACRO(@"/cancelPark")

//使用优惠券(老借口)
#define OLDUSEXOUPON                 URL_MACRO(@"/useCoupon")

//更新订单状态
#define UPDATEORDERSTATE             URL_MACRO(@"/updateOrderState")





/**
 *  月租产权临停支付成功的key值
 */
extern NSString *const KPaySuccess;
/**
 *  预约停车支付成功Key
 */
extern NSString *const KYuYuePaySuccess;
/**
 *  登陆成功
 */
extern NSString *const KLoginSuccess;

@interface NetworkTooler : NSObject

@end







