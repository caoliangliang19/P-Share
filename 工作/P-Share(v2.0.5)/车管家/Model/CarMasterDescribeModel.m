//
//  CarMasterDescribeModel.m
//  P-Share
//
//  Created by fay on 16/3/18.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "CarMasterDescribeModel.h"

@implementation CarMasterDescribeModel
+ (CarMasterDescribeModel *)shareCarMasterDescribeModelWithDic:(NSDictionary *)dic
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
