//
//  MyPointAnnotation.h
//  P-Share
//
//  Created by 杨继垒 on 15/10/8.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface MyPointAnnotation : MAPointAnnotation

@property (nonatomic,copy) NSString *parkState;
@property (nonatomic,copy) NSString *parkDistance;
@property (nonatomic,copy) NSString *parkID;
@property (nonatomic,copy) NSString *parkColorState;
@property (nonatomic,copy) NSString *parkPath;
@property (nonatomic,copy) NSString *isDirect;
@property (nonatomic,copy) NSString *isCooperate;

@property (nonatomic,copy) NSString *peacetimeprice;
@property (nonatomic,copy) NSString *shareprice;
@property (nonatomic,copy) NSString *parkingName;

@property (nonatomic,copy) NSString *parkCanUsed;

@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *stopTime;

@property (nonatomic,copy) NSString *sharePriceComment;
@property (nonatomic,copy) NSString *vipSharePrice;
@property (nonatomic,copy) NSString *vipSharePriceComment;
@property (nonatomic,copy) NSString *vipStartTime;
@property (nonatomic,copy) NSString *vipStopTime;

@property (nonatomic,copy) NSString *parkingLatitude,
                                    *parkingLongitude;

@property (nonatomic ,assign)NSInteger Tag;

@property (nonatomic,copy,setter=setParkingid:) NSString *parkingId;
@end




