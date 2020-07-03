//
//  TemParkingListModel.h
//  P-Share
//
//  Created by fay on 16/2/17.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemParkingListModel : NSObject

@property (nonatomic,copy)NSString *carNumber,
                                   *parkingId,
                                   *parkingName,
                                   *amountPayable,//应付
                                   *beginDate,
                                   *parkingTime,
                                   *orderType,
                                   *amountPaid,//实付
                                   *endDate,
                                   *amountDiscount,//折扣
                                   *orderStatus,
                                   *orderId,
                                   *orderTypeName,
                                   *orderStatusName,
                                   *price,
                                   *customer,
                                   *endTime,
                                   *beginTime,
                                   *createDate,
                                   *monthNum,
                                   *giftAmount,//钱包充值送的钱数
                                   *payTime,
                                   *payTimeForDate,
                                   *payTimeForTime,
                                   *payType,
                                   *reserveDate,
                                   *parkingCode,
                                   *startTime,
                                   *appointmentDate,
                                   *stopTime,
                                   *waitCarCount,//代泊等待车数
                                   *parkingNum,
                                   *orderBeginDate,
                                   *actualBeginDate,
                                   *actualEndDate,
                                   *parkingNo,
                                   *parkerMobile,
                                   *parkerType,
                                   *parkingImagePath,
                                   *validateImagePath,//图片路径
                                   *orderEndDate,
                                   *mobile,//代泊员手机号
                                   *parkerName,//代泊员姓名
                                   *parkerHead,//代泊员头像路径
                                   *voucherStatus,
                                   *parkerId,
                                   *parkerBackId,
                                   *parkerBackName,
                                   *parkerBackHead,
                                   *parkerBackMobile,
                                   *mondayBeginTime,
                                   *mondayEndTime,
                                   *tuesdayBeginTime,
                                   *tuesdayEndTime,
                                   *wednesdayBeginTime,
                                   *wednesdayEndTime,
                                   *thursdayBeginTime,
                                   *thursdayEndTime,
                                   *fridayBeginTime,
                                   *fridayEndTime,
                                   *saturdayBeginTime,
                                   *saturdayEndTime,
                                   *sundayBeginTime,
                                   *sundayEndTime,
                                   *keyBox,
                                   *targetParkingId,
                                   *targetParkingName,
                                   *carType,
                                   *isComment,
                                    *tag,//查看评价相关
                                    *totalityTag,
                                    *carManagerTag,
                                    *businessTag,
                                    *commentContent,
                                    *businessStar,
                                    *totalityStar,
                                    *carManagerStar,
                                    *data,
                                    *parkingAddress,
                                    *effectEndDate,
                                    *tradeNo;


@property (nonatomic,strong)NSDictionary *startEndTime;

+ (TemParkingListModel *)shareTemParkingListModelWithDic:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;

@end


