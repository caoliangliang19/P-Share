//
//  ParkingModel.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/27.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ParkingModel : NSObject

////代泊价格
//@property (nonatomic,copy)NSString *proxy_string;
////优惠价格
//@property (nonatomic,copy)NSString *share_string;
////平时价格
//@property (nonatomic,copy)NSString *peacetimeprice;

@property (nonatomic,copy)NSString *len;

@property (nonatomic,copy) NSString *parkingAddress;
@property (nonatomic,copy,setter=setParkingArea:) NSString *parkingArea;
@property (nonatomic,copy) NSString     *parkingCanUse;
@property (nonatomic,copy) NSString *parkingCity;
@property (nonatomic,copy) NSString      *parkingCount;
@property (nonatomic,copy) NSString *parkingCountry;
@property (nonatomic,copy) NSString *parkingCounty;
@property (nonatomic,copy,setter=setParkingId:) NSString *parkingId;
@property (nonatomic,copy) NSString *parkingInfo;
@property (nonatomic,copy,setter=setParkingLatitude:) NSString *parkingLatitude;
@property (nonatomic,copy,setter=setParkingLongitude:) NSString *parkingLongitude;
@property (nonatomic,copy,setter=setParkingName:) NSString *parkingName;
@property (nonatomic,copy) NSString *parkingPath;
@property (nonatomic,copy) NSString *parkingProvince;
@property (nonatomic,copy) NSString *parkingStatus;
@property (nonatomic,assign) float   parkingChargingStandard;
//@property (nonatomic,strong) NSArray *chargeNorms;
//直连非直连 合作非合作 开放非开放 首屏非首屏
@property (nonatomic,copy) NSString *isDirect;
@property (nonatomic,copy) NSString *isCooperate;
@property (nonatomic,copy) NSString *isOpen;
@property (nonatomic,copy) NSString *isIndex;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *stopTime;

@property (nonatomic,copy) NSString *sharePriceComment;
@property (nonatomic,copy) NSString *vipSharePrice;
@property (nonatomic,copy) NSString *vipSharePriceComment;
@property (nonatomic,copy) NSString *vipStartTime;
@property (nonatomic,copy) NSString *vipStopTime;




@property (nonatomic,copy) NSString *peacetimePrice;
@property (nonatomic,copy) NSString *sharePrice;

@property (nonatomic,copy) NSString *canUse;//是否可代泊（1：不可代泊 2：可代泊）
@property (nonatomic,assign) int isCharge;// 0不可充电 1:可充电
@property (nonatomic,copy) NSString *chargeType;//收费类型（1、时间  2、按次）
@property (nonatomic,strong) NSNumber *isIn;//是否入场（1：待入场 2：已入场）
@property (nonatomic,copy) NSString *priceTimes;//按次收费的话一次收多少钱
@property (nonatomic,strong) NSNumber *ln;
@property (nonatomic,assign) float chargeNormMin;//时间收费，最低价格
//@property (nonatomic,copy,setter=setindexParkingType:) NSString *IndexParkingType;

@property (nonatomic,copy)NSString *nextTime;
@property (nonatomic,copy)NSString *nowTime;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *parkingTime;
@property (nonatomic,copy)NSString *amountPayable;
@property (nonatomic,copy)NSString *carNumber;
@property (nonatomic,copy)NSString *isCommunity;
@property (nonatomic,copy)NSString *parkingPrice;
@property (nonatomic,copy)NSString *statusInfo;
//@property (nonatomic,copy)NSString *homeParkingType;//首页停车场 1:家 2:公司
@property (nonatomic,copy)NSString *parkPriceComment,//代泊描述
                                    *rule;//车场代泊收费规则





@property (nonatomic,copy)NSString *beginDate;
@property (nonatomic,copy)NSString *endDate;
@property (nonatomic,copy)NSString *indexParkingType;//首页停车场类型1:家 2:公司


+ (ParkingModel *)shareParkModel:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;


@end




