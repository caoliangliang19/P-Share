//
//  CouponModel.h
//  P-Share
//
//  Created by fay on 16/4/13.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject

//couponKind : 1停车券 2月租产权券  3代泊券    4车管家券       5洗车券    0通用券
@property (nonatomic,copy)NSString      *couponId,
                                        *vouchersName,
                                        *couponKind,
                                        *channel,
                                        *receiveBegin,
                                        *receiveEnd,
                                        *effectiveBegin,
                                        *effectiveEnd,
                                        *useTime,
                                        *creator,
                                        *createTime,
                                        *effectivetime,
                                        *discount,
                                        *couponType,
                                        *customerMobile,
                                        *exclusionRule,
                                        *couponStatus,
                                        *couponParking,
                                        *customerName,
                                        *receiveTime,
                                        *vouchersType,
                                        *startTime,
                                        *couponOrder,
                                        *stopTime,
                                        *info,
                                        *couponKind2,
                                        *orderType,
                                        *parkingNames;

@property (nonatomic,assign)double      minconsumption,maxdiscount,parAmount,parDiscount;


+ (CouponModel *)shareCouponWithDic:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;



@end
