//
//  NewOrderModel.h
//  P-Share
//
//  Created by 亮亮 on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewOrderModel : NSObject

@property (nonatomic,copy)NSString *amountDiscount;
@property (nonatomic,copy)NSString *amountPaid;
@property (nonatomic,copy)NSString *amountPayable;
@property (nonatomic,copy)NSString *beginTime;
@property (nonatomic,copy)NSString *carNumber;
@property (nonatomic,copy)NSString *createDate;
@property (nonatomic,copy)NSString *createor;
@property (nonatomic,copy)NSString *customerId;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,copy)NSString *orderStatus;
@property (nonatomic,copy)NSString *orderStatusName;
@property (nonatomic,copy)NSString *orderType;
@property (nonatomic,copy)NSString *orderTypeName;
@property (nonatomic,copy)NSString *parkingName;
@property (nonatomic,copy)NSString *parkingId;
@property (nonatomic,copy)NSString *payTime;
@property (nonatomic,copy)NSString *payType;

@end
