//
//  Car.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RootObject.h"

@interface Car : RootObject
@property (nonatomic,copy)  NSString    *carId,
                                        *customerId,
                                        *carBrand,
                                        *tradeName,
                                        *carSeries,
                                        *displacement,
                                        *displacementShow,
                                        *intakeType,
                                        *styleYear,
                                        *carColor,
                                        *carNumber,
                                        *carBuyDate,
                                        *carUseDate,
                                        *carLasts,
                                        *carUseType,
                                        *carSize,
                                        *carIssueDate,
                                        *carImage,
                                        *carMineImage,
                                        *carDriverImage,
                                        *ownerIdNumber,
                                        *carIdentity,
                                        *isAutoPay,
                                        *carName,
                                        *travlledDistance,
                                        *isDefault,
                                        *brandIcon,
                                        *frameNum,
                                        *engineNum;
@end
