//
//  YuYueRequest.h
//  P-SHARE
//
//  Created by fay on 16/10/19.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaiBoInfoV.h"

@interface YuYueRequest : NSObject

+ (void)reloadYuYueTingChe:(Parking *)model Completion:(void (^)(int resultNum,OrderModel *model))completion;

+ (void)reloadDaiBoDataWithParkingModel:(Parking *)parkingModel completion:(void (^)(BOOL hasOrder,OrderModel *order,DaiBoInfoVStatus status,NSString *tenseTime))completion;

+ (void)getBubbleInfoWith:(Parking *)parkModel Completion:(void (^)(Parking *newParkModel))completion;

+ (void)requestDaiBoStatusWithParking:(Parking *)currentParking complete:(void (^)(DaiBoInfoVStatus status,NSString *tenseTime))completion;

/**
    取消代泊订单
 */
+ (void)cancelDaiBoOrderWithOrder:(OrderModel *)order                  success:(void (^)(NSDictionary *dataDic))success
                    error:(void (^)(NSString *error))error
                  failure:(void (^)(NSString *fail))failure;

@end
