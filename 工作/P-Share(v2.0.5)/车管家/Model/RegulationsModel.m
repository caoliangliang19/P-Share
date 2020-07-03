//
//  RegulationsModel.m
//  P-Share
//
//  Created by fay on 16/1/18.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "RegulationsModel.h"

@implementation RegulationsModel
+ (RegulationsModel *)shareRegulationresultModelWithDic:(NSDictionary *)dic
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
