//
//  PingZhengModel.h
//  P-Share
//
//  Created by fay on 16/3/10.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PingZhengModel : NSObject
@property (nonatomic,copy)NSString  *startTime,
                                    *sharePrice,
                                    *parkingName,
                                    *createDate,
                                    *stopTime,
                                    *carNumber;


+ (PingZhengModel *)sharePingZhengModel:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;

@end
