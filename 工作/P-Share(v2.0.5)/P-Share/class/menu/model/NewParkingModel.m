//
//  NewParkingModel.m
//  P-Share
//
//  Created by fay on 16/2/22.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewParkingModel.h"

@implementation NewParkingModel

+ (NewParkingModel *)shareNewParkingModel:(NSDictionary *)dic
{
   return [[self alloc] initWithDic:dic];
}
- (id)initWithDic:(NSDictionary *)dic
{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"indexParkingType"]) {
        _homeParkingType = value;
        
    }
    if ([key isEqualToString:@"isAutoPay"]) {
        
        _isAutoPayOrder = value;
        
    }
}

@end
