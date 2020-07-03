//
//  DaiBoRequest.h
//  P-SHARE
//
//  Created by fay on 16/10/24.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiBoRequest : NSObject
//请求代泊价格
+ (void)requestDaiBoPriceWithURL:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;
//创建代泊订单
+ (void)requestCreateDaiBoOrderWithDic:(NSMutableDictionary *)dic Completion:(void (^)(OrderModel *model))completion Fail:(void (^)(NSString *error))failInfo;

+ (NSString*)getEndTimeDay:(NSString*)day hour:(NSString *)hour miunte:(NSString *)miunte;
+ (NSString *)getToday:(NSDate *)date withFormatter:(NSString *)formatter;

@end
