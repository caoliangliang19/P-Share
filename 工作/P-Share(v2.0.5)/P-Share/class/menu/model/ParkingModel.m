//
//  ParkingModel.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/27.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "ParkingModel.h"
#import <objc/runtime.h>
#import "WZLSerializeKit.h"

//是否使用通用的encode/decode代码一次性encode/decode
//#define USING_ENCODE_KIT    1
@implementation ParkingModel
//
//WZLSERIALIZE_CODER_DECODER();
//
//WZLSERIALIZE_COPY_WITH_ZONE();
//
//WZLSERIALIZE_DESCRIPTION();


+ (ParkingModel *)shareParkModel:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
