//
//  Parking.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RootObject.h"

@interface Parking : RootObject
/**
 *  包含停车场所有属性，存在大量无用数据
 */

@property (nonatomic,assign)NSInteger   canUse, //2:代泊 !2:临停或者导航
                                        defaultScan,
                                        isAutoPay,
                                        isCharge,
                                        isCooperate,//2:代泊或者临停  1:导航
                                        isDirect,
                                        isIn,
                                        isIndex,
                                        isOpen,
                                        isOpenPayment,
                                        parkingCanUse,
                                        parkingCount,
                                        parkingInitialUse;


@property (nonatomic,copy)NSString  *isCollection,
                                    *carNumber,
                                    *rule,
                                    *vipSharePrice,
                                    *sharePrice,
                                    *price,
                                    *region,
                                    *maximumDay,
                                    *maxinumHour,
                                    *chargeNorms,
                                    *chargeType,
                                    *customerId,
                                    *designatedPrice,
                                    *discount,
                                    *endDate,
                                    *beginDate,
                                    *homeParkingId,
                                    *imgUrl,
                                    *indexParkingType,
                                    *invoiceDescribe,
                                    *isCommunity,
                                    *item01,
                                    *len,
                                    *ln,
                                    *maxDate,
                                    *parkBeginTime,
                                    *parkEndTime,
                                    *parkPriceComment,
                                    *parkingAddress,
                                    *parkingArea,
                                    *parkingCity,
                                    *parkingCountry,
                                    *parkingCounty,
                                    *parkingId,
                                    *parkingIdentifier,
                                    *parkingInfo,
                                    *parkingLatitude,
                                    *parkingLongitude,
                                    *parkingName,
                                    *parkingPath,
                                    *parkingProvince,
                                    *parkingStatus,
                                    *peacetimePrice,
                                    *phone,
                                    *priceM,
                                    *priceMax,
                                    *priceP,
                                    *priceTimes,
                                    *qiyuId,
                                    *scheme_discount,
                                    *scheme_exceed_night_price,
                                    *scheme_exceed_price,
                                    *scheme_init_hour,
                                    *scheme_init_price,
                                    *scheme_park_price,
                                    *scheme_proxy_price,
                                    *scheme_top_price,
                                    *sharePriceComment,
                                    *startTime,
                                    *stopTime,
                                    *villageinfo,
                                    *vipSharePriceComment,
                                    *vipStartTime,
                                    *vipStopTime,
                                    *nowTime,
                                    *nextTime,
                                    *statusInfo,
                                    *parkingPrice,
                                    *status,
                                    *amountPayable,
                                    *parkingTime,
                                    *distance,//距离用户的距离
                                    *workParkingId;

@end
