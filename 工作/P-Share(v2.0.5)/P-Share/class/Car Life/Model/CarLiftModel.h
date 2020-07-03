//
//  CarLiftModel.h
//  P-Share
//
//  Created by fay on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarLiftModel : NSObject
@property (nonatomic,copy) NSString         *startDate,
                                            *sort,
                                            *isUsed,
                                            *parkingName,
                                            *imagePath,
                                            *endDate,
                                            *type,
                                            *url,
                                            *ID,
                                            *createor,
                                            *title,
                                            *remainTime,
                                            *parkingId,
                                            *createDate;

+ (CarLiftModel *)shareLiftModelWift:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;


@end
