//
//  RequestModel.h
//  P-Share
//
//  Created by fay on 15/12/29.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionModel.h"
#import "RegulationResultModel.h"
#import "ServerInfoModel.h"
#import "TemParkingListModel.h"
#import "OrderDetailModel.h"
#import "ParkingModel.h"
#import "AFNetworking.h"

@interface RequestModel : NSObject

//post请求
- (void)postRequestWithURL:(NSString *)url WithDic:(NSDictionary *)dic
            needEncryption:(BOOL)need
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     error:(void (^)(NSString *error))error
                   failure:(void (^)(NSString *fail))failure;

- (void)getRequestWithURL:(NSString *)url WithDic:(NSDictionary *)dic
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    error:(void (^)(NSString *error))error
                  failure:(void (^)(NSString *fail))failure;



//获取APPStore上面的版本号
+ (void)requestPShareVersionWithCompletion:(void (^)(VersionModel *versionModel))completion;
//用户注册 post
+ (void)requestRegisterWithURL:(NSString *)URL WithDic:(NSDictionary *)dict Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;


//刚进入页面时调用
+ (void)requestGetPhoneNumWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))fail;
//获取手机验证码,以及登陆
+ (void)requestGetPhoneNumNewWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))fail;

//请求首页家和公司停车场
+ (void)requestFirstVCParkingWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;

//获取车辆违规信息
+ (void)requestRegulationsWithURL:(NSDictionary *)dic Completion:(void (^)(RegulationResultModel *model))completion Error:(void (^)(NSString *errorStr))error Fail:(void (^)(NSString *error))fail;

//获取全国可以查询车辆违规的地区
+ (void)requestPickViewDataWithCompletion:(void (^)(NSArray *arr))completion;

//获取车管家轮播图片
+ (void)requestCarMasterLunBoImageWithURL:(NSString *)URL Completion:(void (^)(NSArray *resultArray))completion Fail:(void (^)(NSString *fail))fail;

//获取车管家服务内容
+ (void)requestCarMasterServerInfoWithParkingID:(NSString *)parkingID ServerID:(NSString *)serverID Completion:(void (^)(ServerInfoModel *serverInfoModel))completion Fail:(void (^)(NSString *errorMsg))errorMsg;

//获取临停缴费订单列表
+ (void)requestTemParkingOrderWithURL:(NSString *)url WithTag:(NSString *)tag Completion:(void (^)(NSArray *resultArray))completion Fail:(void (^)(NSString *error))fail;
//创建临停订单
+ (void)requestCreateTemparkingOrderWithURL:(NSString *)url WithType:(NSString *)type WithDic:(NSMutableDictionary *)dic Completion:(void (^)(TemParkingListModel *model))completion Fail:(void (^)(NSString *error))fail;

//订单与可选优惠券绑定
+ (void)pinlessOrderAndConponWithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;

//修改订单 以及修改优惠券信息
+ (void)changeOrderInfoWithURl:(NSString *)url Completion:(void (^)(NSString *info))completion Fail:(void (^)(NSString *error))fail;

//使用优惠券 post
+ (void)requestWithUserCouponWithURL:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;
//月租产权订单
+ (void)requestCreateMonthRentOrderWithDic:(NSMutableDictionary *)dic Completion:(void (^)(TemParkingListModel *model))completion Fail:(void (^)(NSString *error))fail;

//获取停车场列表
+ (void)requestGetParkingListWithURL:(NSString *)url WithTag:(NSString *)tag Completion:(void (^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))fail;
//历史订单列表
+ (void)requestGetHistoryOrderListWithURL:(NSString *)page WithType:(NSString *)type Completion:(void (^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))fail;
//历史订单详情
+ (void)requestHistoryOrderDetailListWithURL:(NSString *)orderId WithType:(NSString *)orderType Completion:(void (^)(TemParkingListModel *model))completion Fail:(void (^)(NSString *error))fail;
//月租产权获取绑定车辆列表
+ (void)getCarListWithURL:(NSString *)url WithDic:(NSString *)dic Completion:(void (^)(NSMutableDictionary *resultDic))completion Fail:(void (^)(NSString *error))fail;
//提交验证码
+ (void)validateCodeWithURL:(NSString *)url WithDic:(NSDictionary *)dic  Completion:(void (^)(NSString *result))completion Fail:(void (^)(NSString *error))fail;

//调用老的使用优惠券借口
+ (void)UserOldCouponWithURL:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;

//获取问券调查列表
+ (void)getQuestionnairelist:(NSString *)url Completion:(void (^)(NSMutableArray *dataArr))completion fail:(void (^)(NSString *error))Error;

//调查问券提交
+ (void)CommitQuestionnairecWith:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSString *completion))completion Fail:(void (^)(NSString *error))Error;

//地图页面附近是否存在停车场
+ (void)IsExitParkingWithURL:(NSString *)url Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *str))fail;
//添加加油卡
+ (void)requestGetAddOilCardWithURL:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))fail;
//加油卡列表
+ (void)requestAddOilCardListWithURL:(NSString *)orderId WithType:(NSString *)orderType Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))fail;
//加油卡订单列表
+ (void)requestAddCardOrderListWithURL:(NSString *)orderId WithType:(NSString *)orderType Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))fail;

+ (void)requestWinXinRegistByOtherURL:(NSMutableDictionary *)dic code:(NSString *)code  Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;

+ (void)requestWeiXinFirstGoinWithURL:(NSString *)openid Type:(NSString *)type Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;

//用户优惠券小红点是否提醒
+ (void)requestRemindCouponWithURL:(NSString *)url Completion:(void (^)(NSDictionary *dic))completion;

//月租产权未付款已付款订单
+ (void)requestMonthRentOrderListWithURL:(NSInteger)indexPage orderStare:(NSString *)orderState orderType:(NSString *)orderType Completion:(void (^)())completion Fail:(void (^)(NSString *error))fail;


//获取车管家服务信息
+ (void)requestCarMasterServerDescribeWithUrl:(NSString *)url Completion:(void (^)(NSArray *resultArr))completion;

//获取租车界面数据
+ (void)requestRentCarInfoWithURL:(NSString *)url Completion:(void(^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))error;

//获取账户余额
+ (void)requestWalletMoneyWithURL:(NSString *)url Completion:(void (^)(NSString *money))completion Fail:(void(^)(NSString *error))fail;

//获取钱包充值规则
+ (void)requestWalletRuleWithURL:(NSString *)url Completion:(void (^)(NSArray *resultArray))completion Fail:(void(^)(NSString *error))fail;

//钱包支付
+ (void)requestPayWithWalletWithURL:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;

//充值金额记录列表 消费记录列表
+ (void)requstTopUpListAndConsumeListWithURL:(NSString *)Url type:(NSString *)type Completion:(void(^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))isError;

//钱包提交验证码
+ (void)validatePurseBaoCodeWithURL:(NSString *)url WithDic:(NSDictionary *)dic  Completion:(void (^)(NSString *result))completion Fail:(void (^)(NSString *error))fail;

//钱包重置密码提交
+ (void)validateResetPayPasswordWithURL:(NSString *)url WithDic:(NSDictionary *)dic  Completion:(void (^)(NSString *result))completion Fail:(void (^)(NSString *error))fail;

// 查询月租产权代泊未付款订单(小红点)
+ (void)requestOrderPointWithUrl:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *errror))fail;
//添加车辆
+ (void)requestAddCarWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))fail;

//查询车辆列表
+ (void)requestGetCarListWithURL:(NSString *)URL WithPage:(NSInteger)page Completion:(void (^)(NSArray *dataArray))completion Fail:(void (^)(NSString *error))fail;

//查询赠送金额的接口
+ (void)requestCalcGiftAmountWithUrl:(NSInteger)paymoney WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *errror))fail;

//检测手机号并传入手机设备类型
+ (void)requestGetPhoneCodeWithUrl:(NSString *)phoneMoilble WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *errror))fail;
//发票接口
+ (void)requestPostInvoiceInfoWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *fail))fail;
//获取发票信息
+ (void)requestGetLatestInvoiceInfoWithURL:(NSString *)URL Completion:(void (^)(NSDictionary *))completion Fail:(void (^)(NSString *error))fail;

//获取优惠券列表
+ (void)requestGetCouponListWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSMutableArray *dataArr))completion Fail:(void (^)(NSString *error))fail;

+ (void)requestCarWashListWithURL:(NSInteger)indexPage orderStare:(NSString *)orderState orderType:(NSString *)orderType Completion:(void (^)())completion Fail:(void (^)(NSString *error))fail;

//获取发票信息
+ (void)requestGetQueryChargeWithURL:(NSString *)URL Completion:(void (^)(NSDictionary *))completion Fail:(void (^)(NSString *error))fail;
//停车凭证列表
+ (void)requstQueryVoucherPageWithURL:(NSString *)Url type:(NSString *)type Completion:(void(^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))isError;

//获取车的种类
+ (void)requestGetCarKindWith:(NSString *)URL With:(NSDictionary *)dic Completion:(void (^)(NSMutableDictionary *dataDic))completion Fail:(void (^)(NSString *error))fail;
//预约信息不能重复，加载洗车员头像
+ (void)requestQueryAppointmentWithUrl:(NSString *)url WithDic:(NSString *)type Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *errror))fail;

//新代泊相关
+ (void)requestDaiBoWithURL:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;

//获取代泊订单
+ (void)requestDaiBoOrder:(NSString *)url WithType:(NSString *)type WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSArray *dataArray))completion Fail:(void (^)(NSString *error))fail;

//代泊订单列表+代泊评论接口
+ (void)requestQueryFinishParkOrder:(NSString *)url WithType:(NSString *)type WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))fail;

//点击收藏 取消收藏 查看收藏
+ (void)requestCollectionWith:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))Error;

//getParkingStatus气泡中的信息
+ (void)requestGetParkingStatusWith:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(ParkingModel *model))completion Fail:(void (^)(NSString *error))Error;

+ (void)requestGetMonthlyEquityWith:(NSString *)url WithDic:(NSMutableDictionary *)dic  Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))Error;
//可以提供服务的车场列表
+ (void)requestGetParkingListWith:(NSString *)url WithDic:(NSMutableDictionary *)dic type:(NSString *)type Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))Error;

#pragma mark -- 2.0.1新增接口
+ (void)requestGetCarLiftWith:(NSString *)url withDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))Error;


#pragma mark --- get  返回字典
+ (void)getDicWithUrl:(NSString *)url Completion:(void (^)(NSDictionary *dataDic))completion Fail:(void (^)(NSString *error))errorMsg;

#pragma mark --- post 返回字典
+ (void)postGetDiction:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dataDic))completion Fail:(void (^)(NSString *error))errorMsg;


@end

