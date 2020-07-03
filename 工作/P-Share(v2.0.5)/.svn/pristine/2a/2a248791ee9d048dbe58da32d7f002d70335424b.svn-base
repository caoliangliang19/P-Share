//
//  payModel.h
//  P-Share
//
//  Created by fay on 16/1/15.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface payModel : NSObject

@property (nonatomic,copy)NSString* orderName,*orderDescribute,*orderID,*orderPrice;


//回调地址
@property (nonatomic,copy)NSString *AlipayUrl,*WeChatUrl;

- (void)payWithAlipayDic:(NSDictionary *)OrderDic CanOpenAlipay:(void (^)(BOOL isCan))open Completion:(void (^)(BOOL isSuccess))completion Fail:(void (^)(BOOL fail))fail;

- (void)payWithWeChatDic:(NSDictionary *)OrderDic CanOpenWeChat:(void (^)(BOOL isCan))open Completion:(void (^)(BOOL isSuccess))completion Fail:(void (^)(BOOL fail))fail;

//优惠／临停支付失败调用
- (void)payFailWithDic:(NSDictionary *)dic;

//检查优惠券是否可用checkCoupon
- (void)checkCouponIsUsed:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;

//获取停车码
- (void)requestTingCheMaWith:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;


@end
