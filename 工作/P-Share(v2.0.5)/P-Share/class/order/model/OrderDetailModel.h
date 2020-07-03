//
//  OrderDetailModel.h
//  P-Share
//
//  Created by 亮亮 on 16/2/24.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject
@property (nonatomic,copy)NSString *actualBeginDate;
@property (nonatomic,copy)NSString *actualEndDate;
@property (nonatomic,copy)NSString *amountDiscount;
@property (nonatomic,copy)NSString *amountPaid;
@property (nonatomic,copy)NSString *amountPayable;
@property (nonatomic,copy)NSString *carNumber;
@property (nonatomic,copy)NSString *orderBeginDate;
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,copy)NSString *orderStatus;
@property (nonatomic,copy)NSString *orderStatusName;
@property (nonatomic,copy)NSString *orderType;
@property (nonatomic,copy)NSString *orderTypeName;
@property (nonatomic,copy)NSString *parkingId;
@property (nonatomic,copy)NSString *parkingName;
@property (nonatomic,copy)NSString *parkingNo;
@property (nonatomic,copy)NSString *payTime;
@property (nonatomic,copy)NSString *payType;
@property (nonatomic,copy)NSString *parkingCode;

@end
